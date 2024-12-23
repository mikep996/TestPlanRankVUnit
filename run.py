#!/usr/bin/env python3
<<<<<<< HEAD
####
=======
#
>>>>>>> 5a9dd0cd1c2dcbb93afe78aed50f9d880cf45801
from vunit import VUnit
from pathlib import Path
import os

# Setting root as path to the example directory
root = Path(__file__).parent

vu = VUnit.from_argv()

vu.add_verilog_builtins()

lib = vu.add_library("lib")

# adding project sources (with coverage)
lib.add_source_files(root / "src" / "*.sv")

lib.set_compile_option("rivierapro.vlog_flags", ["-coverage", "sbaecm", "-coverage_options", "onevar+relational+fsmsequence"])

# adding testbench sources (without coverage)
lib.add_source_files(root / "tb" / "*.sv")

lib.set_sim_option("enable_coverage", True)

tb = lib.test_bench("tb")

lib.set_sim_option("rivierapro.vsim_flags", ["-acdb +access +r+m+base64_enc -acdb_cov sbaecmtf"])

# toggle coverage 
lib.set_sim_option("rivierapro.init_files.before_run", ["./src/toggle.do"])

# folder for simulation outputs
if not os.path.exist("./output"):
  os.mkdir('./output')

vu.main()


