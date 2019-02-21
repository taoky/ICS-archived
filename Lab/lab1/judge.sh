for index in {1..100}
do
  i0=$(shuf -i 1-32767 -n 1)
  i1=$(shuf -i 1-32767 -n 1)
  j0=$(echo "obase=16; $i0" | bc)
  j1=$(echo "obase=16; $i1" | bc)
  echo "Testing R0=$j0, R1=$i1"
  lc3_result=$(echo -e "r r0 $j0\nr r1 $j1\nb s 302b\nc\nquit\n" | lc3sim asm9.obj | tail -3 | head -1 | cut -c 4-8)
  c_result=$(./lab1 $j0 $j1 16)
  if [ $lc3_result != $c_result ]
  then
    echo "FAILED!"
    echo "lc3_result: $lc3_result, expected $c_result"
    exit
  fi
done
