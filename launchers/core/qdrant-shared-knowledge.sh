#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$DIR/qdrant.sh" shared-knowledge
