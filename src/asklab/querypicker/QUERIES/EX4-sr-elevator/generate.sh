#! /bin/sh

BASE=../BASE/

REASONING=../Sophisticated-Reasoning/

# Build files ASP Ontoly

FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_elevator.lp $REASONING/Integration/SR-RE-01-truthworthiness/obs_init_state_elevator.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_1.lp output_sr_re_01_01.lp"
OUTPUT=FULL-step1.txt
cat $FILES > $OUTPUT

FILES="../TEST/translation.lp $REASONING/Integration/SR-RE-01-truthworthiness/obs_init_state_elevator.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_1.lp output_sr_re_01_01.lp"
OUTPUT=FULL-step1-new.txt
cat $FILES > $OUTPUT

FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_elevator.lp $REASONING/Integration/SR-RE-01-truthworthiness/obs_init_state_elevator.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_2.lp output_sr_re_01_02.lp"
OUTPUT=FULL-step2.txt
cat $FILES > $OUTPUT

FILES="$BASE/step1-BASE.lp $BASE/theory.lp $BASE/theory-maxint.lp output.lp $BASE/step1.lp $BASE/step2.lp"
OUTPUT=FULL-step3.txt
cat $FILES > $OUTPUT

FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_elevator.lp $REASONING/Integration/SR-RE-01-truthworthiness/obs_init_state_elevator.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_3.lp output_sr_re_01_03.lp"
OUTPUT=FULL-step4.txt
cat $FILES > $OUTPUT

FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_elevator.lp $REASONING/Integration/SR-RE-01-truthworthiness/obs_init_state_elevator.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_4.lp output_sr_re_01_04.lp"
OUTPUT=FULL-step4-ext.txt
cat $FILES > $OUTPUT


# Build files OWL Ontoly Case 1
FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_driven.lp $REASONING/Integration/SR-RE-01-truthworthiness/ontology_init_ele_0.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_1_onto.lp output_sr_re_01_01.lp"
OUTPUT=FULL-SR-ER-01-ELE-01-00.txt
cat $FILES > $OUTPUT

FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_driven.lp $REASONING/Integration/SR-RE-01-truthworthiness/ontology_init_ele_0.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_2_onto.lp output_sr_re_01_02.lp"
OUTPUT=FULL-SR-ER-01-ELE-02-00.txt
cat $FILES > $OUTPUT


FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_driven.lp $REASONING/Integration/SR-RE-01-truthworthiness/ontology_init_ele_0.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_3_onto.lp output_sr_re_01_03.lp"
OUTPUT=FULL-SR-ER-01-ELE-03-00.txt
cat $FILES > $OUTPUT

FILES="$REASONING/Integration/SR-RE-01-truthworthiness/ontology_driven.lp $REASONING/Integration/SR-RE-01-truthworthiness/ontology_init_ele_0.lp $REASONING/Integration/SR-RE-01-truthworthiness/reasoning_2_4_onto.lp output_sr_re_01_04.lp"
OUTPUT=FULL-SR-ER-01-ELE-04-00.txt
cat $FILES > $OUTPUT