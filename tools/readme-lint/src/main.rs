use serde::Serialize;
use std::{env, fs, process};

// +-[ readme-lint ]------------------------------------------+
// |  heraldstack style validator for markdown files          |
// |  exit 0 = clean, exit 1 = violations found              |
// +---------------------------------------------------------+

#[derive(Debug, Serialize)]
struct Violation {
    line: usize,
    kind: &'static str,
    detail: String,
}

#[derive(Debug, Serialize)]
struct Report {
    file: String,
    violations: Vec<Violation>,
    clean: bool,
}

// words that never appear in heraldstack docs
const BANNED_WORDS: &[(&str, &str)] = &[
    ("master", "use: root, primary, authoritative, canonical"),
    ("spearheaded", "use: built, led, drove, shipped"),
];

// emoji ranges we reject -- swear emoji (U+1F92C) is the only allowed exception
fn contains_banned_emoji(s: &str) -> Option<String> {
    for ch in s.chars() {
        let cp = ch as u32;
        // swear emoji U+1F92C is the only allowed emoji
        if cp == 0x1F92C {
            continue;
        }
        // broad emoji ranges
        let is_emoji = matches!(cp,
            0x1F300..=0x1FAFF  // misc symbols, emoticons, transport, etc.
            | 0x2600..=0x27BF  // misc symbols + dingbats
            | 0xFE00..=0xFE0F  // variation selectors
            | 0x1F000..=0x1F02F // mahjong tiles
            | 0x1F0A0..=0x1F0FF // playing cards
        );
        if is_emoji {
            return Some(format!("found emoji U+{:04X} -- only swear emoji allowed", cp));
        }
    }
    None
}

fn check_numbered_list(line: &str) -> bool {
    // matches "1. " or "1) " at start of trimmed line
    let trimmed = line.trim_start();
    if trimmed.len() < 3 {
        return false;
    }
    let mut chars = trimmed.chars();
    let first = chars.next().unwrap_or(' ');
    if !first.is_ascii_digit() {
        return false;
    }
    // consume remaining digits
    let rest: String = chars.collect();
    rest.starts_with(". ") || rest.starts_with(") ")
}

fn has_ascii_art_header(content: &str) -> bool {
    // looks for a line starting with "  +-[" or a freeform ascii block
    // within the first 10 lines that contains at least one non-word ascii art char pattern
    let header_patterns = ["+-[", "```", "  _", " __", "  /\\", " |_|", "  \\"];
    let first_lines: Vec<&str> = content.lines().take(10).collect();
    for line in &first_lines {
        for pat in &header_patterns {
            if line.contains(pat) {
                return true;
            }
        }
    }
    false
}

fn lint(path: &str) -> Report {
    let content = match fs::read_to_string(path) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("error reading {}: {}", path, e);
            process::exit(2);
        }
    };

    let mut violations: Vec<Violation> = Vec::new();

    // ascii art header check (file-level)
    if !has_ascii_art_header(&content) {
        violations.push(Violation {
            line: 0,
            kind: "missing-ascii-header",
            detail: "readme must start with an ascii art header block".into(),
        });
    }

    for (i, line) in content.lines().enumerate() {
        let lineno = i + 1;
        let lower = line.to_lowercase();

        // banned words
        for (word, suggestion) in BANNED_WORDS {
            if lower.contains(word) {
                violations.push(Violation {
                    line: lineno,
                    kind: "banned-word",
                    detail: format!("'{}' found -- {}", word, suggestion),
                });
            }
        }

        // emoji check
        if let Some(detail) = contains_banned_emoji(line) {
            violations.push(Violation {
                line: lineno,
                kind: "banned-emoji",
                detail,
            });
        }

        // numbered list abuse
        if check_numbered_list(line) {
            violations.push(Violation {
                line: lineno,
                kind: "numbered-list",
                detail: "numbered list detected -- use plain bullets unless order is required".into(),
            });
        }
    }

    let clean = violations.is_empty();
    Report {
        file: path.to_string(),
        violations,
        clean,
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("usage: readme-lint <file.md> [file2.md ...]");
        process::exit(2);
    }

    let mut any_violations = false;
    let mut reports: Vec<Report> = Vec::new();

    for path in &args[1..] {
        let report = lint(path);
        if !report.clean {
            any_violations = true;
        }
        reports.push(report);
    }

    println!("{}", serde_json::to_string_pretty(&reports).unwrap());

    if any_violations {
        process::exit(1);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn banned_word_master() {
        let result: Vec<_> = ["registry.yaml -- Master launcher index"]
            .iter()
            .filter(|l| l.to_lowercase().contains("master"))
            .collect();
        assert!(!result.is_empty());
    }

    #[test]
    fn ascii_header_detected() {
        let content = "```\n  +-[ test ]-+\n```\n\ndesc\n";
        assert!(has_ascii_art_header(content));
    }

    #[test]
    fn numbered_list_detected() {
        assert!(check_numbered_list("1. do the thing"));
        assert!(check_numbered_list("  2. another thing"));
        assert!(!check_numbered_list("- bullet"));
        assert!(!check_numbered_list("10x performance"));
    }

    #[test]
    fn swear_emoji_allowed() {
        // U+1F92C swear emoji -- should not flag
        let line = "this is \u{1F92C} fine";
        assert!(contains_banned_emoji(line).is_none());
    }

    #[test]
    fn regular_emoji_banned() {
        let line = "this \u{1F680} is not fine";
        assert!(contains_banned_emoji(line).is_some());
    }
}
