addi  s1,s1,3
lui   s1,0xFFFFF 
switled:
	lw s2,0x70(s1)
	addi s0 s2 0
	addi a1 x0 0
	addi a2 x0 0
	addi a3 x0 0
                sw   s2,0x60(s1) 
	andi a2 s0 0x000000ff #a2 是数字A
	srli s0 s0 8 
	andi a3 s0 0x000000ff #a3 是数字B
	srli s0 s0 13
	#对数字A 和数字B进行符号位扩展的数字储存在t4 t5中
	slli t4 a2 24
	srai t4 t4 24
	slli t5 a3 24
	srai t5 t5 24
	
	andi a4,s0,0x00000007
	addi a5 x0 0
beq a4 a5 Done
addi a5 a5 1
beq a4 a5 Add
addi a5 a5 1
beq a4 a5 Sub
addi a5 a5 1
beq a4 a5 And
addi a5 a5 1
beq a4 a5 Or
addi a5 a5 1
beq a4 a5 Sll
addi a5 a5 1
beq a4 a5 Sra
addi a5 a5 1
beq a4 a5 Mul
Add:
	add a1 t4 t5
	j Done
Sub:     
	sub a1 t4 t5
	j Done	
And:    and a1 a2 a3
	j Done
Or :
	or a1 a2 a3
	j Done
Sll: 
	sll a1 t4 t5
	j Done
Sra: 	
	sra a1 t4 t5
	j Done
Mul:	
	addi t3 x0 1 #临时变量t3=1
	xori a6 a2 0xff
	addi a6 a6 1
	slli a6 a6 8  #a6 是[-x]补
	slli a2 a2 8
	slli a3 a3 1
	addi t0 x0 8
booth:  sub t0 t0 t3
	bge t0 x0 judge
	srli a1 a1 1
	slli a1 a1 17
	srai a1 a1 17
	j Done
judge:  andi t1 a3 0x03
	addi t2 x0 2
	beq t1 t2  label
	addi t2 x0 1
	beq t1 t2 label2
	j shift
label:   
	add a1 a1 a6
	j shift
label2:	
	add a1 a1 a2
	j shift
shift:
	beq t0 x0 booth
	slli a1 a1 16
	srai a1 a1 1
	srli a1 a1 16
	srli a3 a3 1
	j booth
Done:	
        sw   a1,0x00(s1)
        jal  switled




	   
