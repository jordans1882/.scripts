#!/usr/bin/env python3

import argparse
import os
import re
import random
import sys

# create parser
parser = argparse.ArgumentParser()


# add arguments to the parser
parser.add_argument("--tname", nargs=1, help="Theme name")

# parse the arguments
args = parser.parse_args()

if(args.tname != None):
    given_tname = args.tname[0]
else:
    given_tname = ""

print(given_tname)

# Helper funs (only used once...)
def find_color_bounds(lst, bstring, estring):
    return [i for i, x in enumerate(lst) if x==bstring or x==estring]

colors_dir = "$HOME/git_repos/base16-alacritty/colors"
colors_fns = os.listdir(colors_dir)

rindex = random.choice(range(len(colors_fns)))

# read in alacritty theme
atheme_fp = "$HOME/.config/alacritty/alacritty.yml"
atheme_fs = open(atheme_fp, 'r')
atheme_con = atheme_fs.read()
atheme_conlist = atheme_con.split('\n')
atheme_fs.close()

# Define bounding strings
beg_str = '# ALACRITTY_COLORS_BEGIN'
end_str = '# ALACRITTY_COLORS_END'

bounds = find_color_bounds(atheme_conlist, beg_str, end_str)
bbound = bounds[0]
bound_width = bounds[1] - bounds[0]

for i in range(bound_width-1):
    del atheme_conlist[bbound+1]


if(given_tname == ''):
    ctheme_fp = os.path.join(colors_dir, colors_fns[rindex])
else:
    inlist = any([given_tname == x for x in colors_fns])
    # add a check if given_tname in list
    if inlist:
        ctheme_fp = os.path.join(colors_dir, given_tname)
    else:
        print(f"Error: {given_tname} not in base16-themes")
        sys.exit()
ctheme_fs = open(ctheme_fp, 'r')
ctheme_con = ctheme_fs.read()
ctheme_conlist = ctheme_con.split('\n')
ctheme_fs.close()

for i in range(len(ctheme_conlist)):
    atheme_conlist.insert(bbound + 1+ i, ctheme_conlist[i])

new_atheme_con = '\n'.join(atheme_conlist)

atheme_fs = open(atheme_fp, 'w')
atheme_fs.write(new_atheme_con)
