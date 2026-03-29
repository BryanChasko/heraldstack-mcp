import subprocess, sys, os, threading

proc = subprocess.Popen(
    ['docker', 'run', '-i', '--rm',
     '-e', 'GITHUB_PERSONAL_ACCESS_TOKEN=' + os.environ.get('GITHUB_PERSONAL_ACCESS_TOKEN', ''),
     'ghcr.io/github/github-mcp-server', 'stdio'],
    stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL
)

def fwd_stdin():
    for line in sys.stdin.buffer:
        proc.stdin.write(line)
        proc.stdin.flush()
    try: proc.stdin.close()
    except: pass

threading.Thread(target=fwd_stdin, daemon=True).start()

while True:
    chunk = proc.stdout.read1(4096)
    if not chunk:
        break
    sys.stdout.buffer.write(chunk)
    sys.stdout.buffer.flush()

sys.exit(proc.wait())
