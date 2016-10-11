# Programmer: Jeffrey Cuadros
# Project #2
#Course: CSC320, fall 2016
#Description: This program uses the Recursive Euclidean Algorithm to calculate GCD
.data
Intro: .asciiz "**Recursive Euclidean Algorithm to calculate GCD**\n"
MsgA: .asciiz "Type a positive integer for A: "
MsgB: .asciiz "Type a positive integer for B: "
errmsg: .asciiz "Sorry, you must enter a positive integer (>0). Please try again. "
Result: .asciiz "The GCD is "

MsgH: .asciiz "Integer for H: "
MsgL: .asciiz "Integer for L: "

.globl main

.text
main:
  	
  	li $v0,4        # syscall to print String
    	la $a0,Intro    # load address of Intro
    	syscall         # print Prompt String  
  
   	li $v0,4        # syscall to print String
    	la $a0,MsgA     # load address of Msg1
    	syscall         # print Prompt String  
	
    	li $v0,5        # syscall to read integer
    	syscall         # read integer n
    	move $t0,$v0    # move integer n to $t0
    	
    	slti $t2, $t0, 1  	# if (n < 1), print error msg and Exit
        bne $t2, $zero, error
        
        
        li $v0,4        # syscall to print String
    	la $a0,MsgB     # load address of Msg1
    	syscall         # print Prompt String  
	
    	li $v0,5        # syscall to read integer
    	syscall         # read integer n
    	move $t1,$v0    # move integer n to $t0
    	
    	slti $t2, $t1, 1  	# if (n < 1), print error msg and Exit
        bne $t2, $zero, error
        
        
        #CHECK which one is greater and call gdc (Big, Small)
        #Reserve 4 spots in the stack for the conditional statemnet 
        
        slt $t2, $t0, $t1
        beq $t2, $zero, skip #If first input  is greater then we do not do anything...
        #Otherwise we swap the values
        add $t2 , $zero, $a0
        
        move $a0, $a1
        move $a1 , $t2
        
        li $v0,4        # syscall to print String
    	la $a0,MsgH     # load address of Msg1
    	syscall
    	
    	li $v0,1	# print_int syscall code = 1
	move $a0, $a0   # print n! (result)
	syscall	
    	
    	li $v0,4        # syscall to print String
    	la $a0,MsgL     # load address of Msg1
    	syscall
        
        li $v0,1	# print_int syscall code = 1
	move $a0, $t3   # print n! (result)
	syscall	
        
        skip:
        
    	move $a0, $t0
    	move $a1, $t1	# Move Argument A to $a0
    	jal gdcFunc	# Save current PC in $ra, and call fact (int n)
    	
    	move $t3,$v0	# Return value saved in $v0, move to $t3
    	
    	li $v0 ,4       # syscall to print String
    	la $a0, Result  # load address of Result
    	syscall         # print Prompt String 
    	
    	li $v0,1	# print_int syscall code = 1
	move $a0, $t3   # print n! (result)
	syscall	
    	j Exit
    
error:   # Print string err_msg - error message
	li	$v0, 4
	la	$a0, errmsg
	syscall
	
Exit:   li $v0,10       # EXIT 
    	syscall  

gdcFunc:
	addi $sp, $sp, -12 # space for two words
	
	sw $ra, 8($sp)    # save return address
	sw $a0, 4($sp)    # save return address
	sw $a1, 0($sp)    # temporary variable to hold n
	
	li $v0, 1         # initially, the return value $v0=1
	ble $a0, $zero, gdc_return
	
	addi $a0, $a0, -1
	jal gdcFunc
	lw $a0, 0($sp)    # retrieve original n
	mul $v0, $v0, $a0 # n * fact(n - 1)

gdc_return:
	lw $ra 4($sp)     # restore $ra
	addi $sp, $sp, 8  # restore $sp
	jr $ra            # back to caller

