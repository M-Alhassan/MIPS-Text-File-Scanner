
#----------------data segment------------------
.data
filename: .asciiz "/input.txt"
filewords: .space 1024 
 

letter: .asciiz "\n Letter = " 
Other: .asciiz "\n Others = "    
Digits: .asciiz "\n Digits = "    
word: .asciiz "\n words = "    
filenot: .asciiz "file not found "    


#----------------code segment----------------

#loading the file
.text
li $v0,13
la $a0,filename
li $a1,0
syscall
move $s0,$v0

#reading the file
li $v0,14
move $a0,$s0

la $a1,filewords
la $a2,1024
syscall

li $t3,0
la $t0,filewords     

lb $t1,0($t0)			#getting the first index of the array
beq $t1,$zero,filenotfound
li $t2,0
li $s0,0	#letters
li $s1,0	#others
li $s2,0	#digits
li $s3,0	#words

letter1:
lb $t1,0($t0)			#getting the first letter of the array
bge $t2,1000,letterend1	
addi $t0,$t0,1			#i++
addi $t2,$t2,1
   
beq $t1,32,other
beq $t1,0,letter1
bge $t1,97,checksmalllett
bge $t1,65,checkbiglett
bge $t1,48,checkdigit

addi $s1,$s1,1			#other++

j letter1

checkbiglett:
ble $t1,90,biglett
j other
j letter1

biglett:
addi $t3,$t3,1			#capital_letter++
j letter1

checksmalllett:
ble $t1,122,smalllett
j other                      
j letter1
smalllett:
addi $t3,$t3,1			#small_letter++
j letter1

checkdigit:
ble $t1,57,digit
j other

j letter1

digit:
addi $s2,$s2,1
j letter1

other:
addi $s1,$s1,1			#other++
j letter1


letterend1:
move $s0,$t3


#for words:
li $t3,0
la $t0,filewords
li $t2,0
lb $t1,0($t0)
beq $t1,32,words1		#checking if the first character is a space
addi $t3,$t3,1

words1:
lb $t1,0($t0)
bge $t2,1000,wordsend1         
addi $t0,$t0,1
addi $t2,$t2,1

beq $t1,32,spacefound
j words1
spacefound:
lb $t1,0($t0)
bge $t2,1000,wordsend1
addi $t0,$t0,1            
addi $t2,$t2,1
beq $t1,32,spacefound		#checking for a space
beq $t1,0,spacefound		#checking for null
ble $t1,65,words1		#checking for anything other than an alphabet

wordfind:
addi $t3,$t3,1			#words++

j words1

wordsend1:
move $s3,$t3			#storing number of words in register $s3

la $a0,letter
li $v0,4
syscall               

move $a0,$s0
li $v0,1
syscall

la $a0,Other
li $v0,4
syscall

move $a0,$s1
li $v0,1
syscall

la $a0,Digits
li $v0,4
syscall


move $a0,$s2
li $v0,1
syscall

la $a0,word
li $v0,4
syscall

move $a0,$s3
li $v0,1
syscall

j exit

filenotfound:			#displaying the "file not found message"
la $a0,filenot
li $v0,4
syscall

exit:
li $v0, 10			#terminate the program
syscall
