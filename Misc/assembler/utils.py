import sys
from pathlib import Path
import regex


class DebugPrinter(object):
    def __init__(self, enable=False):
        self.enabled = enable

    def __call__(self, *args, **kwargs):
        if self.enabled:
            eprint(*args, **kwargs)

    def enable(self):
        self.enabled = True

    def disable(self):
        self.enabled = False


dprint = DebugPrinter()


def eprint(*args, **kwargs):
    print(*args, **kwargs, file=sys.stderr)


def get_object_filename(filename: str) -> str:
    p = Path(filename)
    return str(p.parent) + "/" + p.stem + ".o"


def str_to_addr(s: str) -> int:
    s = s.lower()
    if s[0] == 'x':
        return int(s[1:], 16)
    elif s[0] == '#':
        return int(s[1:], 10)
    else:
        return int(s, 10)


def recom(s: str):
    # ignore case regex
    return regex.compile(s, flags=regex.I)


def str_decode(s: str):
    return s.encode("ascii").decode("unicode_escape").replace("\\e", "\x1B").replace("\\E", "\x1B")

# about regex parts

r_whitespace = r"\s*"  # 0 or more white spaces
r_strong_whitespace = r"\s+"  # 1 or more white spaces
r_raw_comment = r"(?:;.*)?$"
r_comment = r_whitespace + r_raw_comment  # comment part
r_split = r_whitespace + r"," + r_whitespace  # ',' with 0 or more white spaces around
r_raw_label = r"([A-Za-z][A-Za-z0-9_]*)"
r_label = r_whitespace + r_raw_label + "?" + r_whitespace  # label
r_head_label = r_whitespace + "(?:" + r_raw_label + r_strong_whitespace + ")?" + r_whitespace
r_reg = r_whitespace + r"R([0-7])"  # register
r_imm = r_whitespace + r"(x[0-9A-Fa-f]{1,4}|#?-?[0-9]+)"  # immediate number
r_str = r_whitespace + r"\"(.*?[^\\])\""  # from https://stackoverflow.com/questions/171480/regex-grabbing-values-between-quotation-marks
