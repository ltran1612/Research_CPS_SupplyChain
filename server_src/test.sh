curl -X POST \
-F solver="3" \
-F aspName="FULL-SR-ER-01-ELE-01-00.txt" \
-F file1=@"../src/asklab/querypicker/QUERIES/BASE/cpsframework-v3-base-development-backup.owl" \
-F file2=@"../src/asklab/querypicker/QUERIES/EX4-sr-elevator/cpsframework-v3-sr-Elevator-Configuration.owl" \
-F file3=@"../src/asklab/querypicker/QUERIES/EX4-sr-elevator/cpsframework-v3-sr-Elevator-Initial.owl" \
-F file4=@"../src/asklab/querypicker/QUERIES/EX4-sr-elevator/FULL-SR-ER-01-ELE-01-00.txt" \
http://127.0.0.1:9000/reasoning -o result.txt
