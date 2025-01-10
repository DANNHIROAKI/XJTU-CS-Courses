#!/bin/bash
python simulator.py --default-switch-type=dv_router --default-host-type=dv_comprehensive_test_utils.TestHost dv_comprehensive_test_utils topos.rand --switches=5 --links=10 --seed=1 dv_comprehensive_test --seed=43
