#! /bin/sh
echo "Build Contract ASP Files"

BASE=../BASE/

REASONING=../Sophisticated-Reasoning/

# Build files OWL Ontoly Case 1
# Most/Least Trustworthy Component (Case 0)
FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_driven.lp $REASONING/Integration/SR-RE-01-truthworthiness/ontology_init_ele_0.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_1_onto.lp output_sr_re_01_01.lp"
OUTPUT=CONTRACT-01.txt
cat $FILES > $OUTPUT

# Check unsatisfied concerns (Case 0) 
FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_driven.lp $REASONING/Integration/SR-RE-01-truthworthiness/ontology_init_ele_0.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_2_onto.lp output_sr_re_01_02.lp"
OUTPUT=CONTRACT-02.txt
cat $FILES > $OUTPUT

# Mitigation Strategy: Random method + List all possible solutions (Case 0)
FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_driven.lp $REASONING/Integration/SR-RE-01-truthworthiness/ontology_init_ele_0.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_3_onto.lp output_sr_re_01_03.lp"
OUTPUT=CONTRACT-03.txt
cat $FILES > $OUTPUT