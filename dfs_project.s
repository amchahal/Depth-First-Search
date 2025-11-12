////////////////////////
//                    //
//       main         //
//                    //
////////////////////////
// You can modify main function to test your own test cases.

    LDA X0, maze      //Init maze array
    LDA X1, visit     //Init visit array
    LDA X3, path      //Init path array

	ADDI X2, XZR, #4 // loc = 4
	ADDI X4, XZR, #3 // width = 3
	BL check
	STOP




    	ADD X3, XZR, XZR  //Init start indeX
	ADDI X4, XZR, #3  //Width
    	BL possibleStarts
	PUTINT X7
	STOP


////////////////////////
//                    //
//        find        //
//                    //
////////////////////////
find:
	// input:
    // 	X0: The address of (pointer to) the array.
	// 	X1: loc, which is a value that we are looking for in the array.
	// output:
	// 	X7: -1 or length

	SUBI SP, SP, #24
	STUR FP, [SP, #0]
	ADDI FP, SP, #16
	STUR LR, [FP, #0]
	STUR X0, [FP, #-8]

	ADDI X9, XZR, #0 // i = 0
	
loop:	
	LDUR X10, [X0, #0] // load *arr+i
	ADDIS XZR, X10, #1 // check if *(arr+i) == -1
	B.EQ retfind1
	CMP X10, X1 // check if *(arr+1) == loc
	B.EQ retfind2
	ADDI X9, X9, #1 // i++
	ADDI X0, X0, #8 // increment array
	B loop

retfind1: 	
	ADD X7, XZR, X9 // return i
	B endfind

retfind2:	
	SUBI X7, XZR, #1 // return -1

endfind: 	
	LDUR X0, [FP, #-8]
	LDUR LR, [FP, #0]
	LDUR FP, [SP, #0]
	ADDI SP, SP, #24
	BR LR


////////////////////////
//                    //
//       display      //
//                    //
////////////////////////
display:
	// input:
	//	X0: The pointer of the maze array.
  	//	X1: The pointer of the path array.
	//	X2: The width of the maze.
 	// output:
	//	None, but the maze should be displayed in the console

	SUBI SP, SP, #56
	STUR FP, [SP, #0]
	ADDI FP, SP, #48
	STUR LR, [FP, #0]
	STUR X0, [FP, #-8] // X0 is maze
	STUR X1, [FP, #-16] // X1 is path
	STUR X2, [FP, #-24] // X2 is width
	STUR X9, [FP, #-32] // store value of i
	STUR X10, [FP, #-40] // store value of j

	ADDI X8, XZR, #0 // begin = 0
	ADDI X9, XZR, #0 // i = 0
	ADDI X14, XZR, #10 // newline character
	ADDI X15, XZR, #32 // space character
	
disploop:
	ADDI X10, XZR, #0 // j = 0
	CMP X9, X2 // i comp width
	B.GE dispend

miniloop:
	CMP X10, X2 //compare j to width
	B.GE miniend

	MOV X0, X1 // change X0 to path
	ADD X1, X8, X10 // loc = begin+j
	STUR X9, [FP, #-32] // store value of i
	STUR X10, [FP, #-40] // store value of j
	BL find
	
	LDUR X9, [FP, #-32] // load value of i
	LDUR X10, [FP, #-40] // load value of j
	LDUR X0, [FP, #-8] // reload initial X0
	LDUR X1, [FP, #-16] // reload initial X1
	
	ADDIS XZR, X7, #1 // check if X7 is -1
	B.EQ next

	ADD X11, X10, X8 // X11 = begin + j
	LSL X11, X11, #3 // X11*8 
	ADD X12, X0, X11 // maze+begin+j
	LDUR X12, [X12, #0] // load the value to X12
	putint X12 // print *maze+begin+j
	putchar X15 // print space
	ADDI X10, X10, #1 // j++
	B miniloop
	
next: 	
	ADDI X13, XZR, #3 
	putint X13 // print 3
	putchar X15 // print space
	ADDI X10, X10, #1
	B miniloop
	
miniend:
	putchar X14 // print new line
	ADD X8, X8, X2 // begin += width
	ADDI X9, X9, #1 // i++
	B disploop

dispend: 
	putchar X14
	LDUR X10, [FP, #-40] // store value of j
	LDUR X9, [FP, #-32] // store value of i
	LDUR X2, [FP, #-24]
	LDUR X1, [FP, #-16]
	LDUR X0, [FP, #-8]
	LDUR LR, [FP, #0]
	LDUR FP, [SP, #0]
	ADDI SP, SP, #56

	BR LR


////////////////////////
//                    //
//       check        //
//                    //
////////////////////////
check:
	// input:
    // 	X0: The address of (pointer to) the maze array.
  	//	X1: The address of (pointer to) the visit array.
	//	X2: Location that we are checking.
	//	X3: The address of (pointer to) the path array.
	//	X4: The width of the maze.
	// output:
	// 	X7: True or False

	SUBI SP, SP, #40
	STUR FP, [SP, #0]
	ADDI FP, SP, #32
	STUR LR, [FP, #0]
	STUR X1, [FP, #-8] // X1 is visit
	STUR X2, [FP, #-16] // X2 is location
	STUR X3, [FP, #-24] // X3 is path


	ADDI X9, XZR, #0 // i = 0

checkloop:
	LDUR X10, [X1, #0] // load *(visit)
	ADDI X11, X10, #1 // check if value is = -1
	CMPI X11, #0
	B.EQ endcheck

	CMP X10, X2 // check if *(visit + i) == loc
	B.EQ endzero

	ADDI X9, X9, #1 // i++
	ADDI X1, X1, #8 // increment visit by 8 to move to next address
	B checkloop 

endcheck:
	ADD X11, X2, XZR // temp register to store X2
	MOV X2, X3 // move X3 to X2 (X2 = path)
	MOV X3, X11 // move X2 to X3 (X3 = loc)
	LDUR X1, [FP, #-8] // load initial X1 value
	BL dfs
	B deallocatecheck
	
endzero:
	ADDI X7, XZR, #0 // set X7 to 0

deallocatecheck:
	LDUR X3, [FP, #-24]
	LDUR X2, [FP, #-16]
	LDUR X1, [FP, #-8]
	LDUR LR, [FP, #0]
	LDUR FP, [SP, #0]
	ADDI SP, SP, #40
	BR LR

////////////////////////
//                    //
//        dfs         //
//                    //
////////////////////////
dfs:
	// input:
	//	X0: Pointer to the maze array.
	//	X1: Pointer to the visit array.
	//	X2: Pointer to the path array.
	//	X3: The current location(place).
	//	X4: The width of the maze.
 	// output:
	// 	X7: True or False

	SUBI SP, SP, #48
	STUR FP, [SP, #0]
	ADDI FP, SP, #40
	STUR LR, [FP, #0]
	STUR X0, [FP, #-8] // store X0
	STUR X1, [FP, #-16] // store X1
	STUR X2, [FP, #-24] // store X2
	STUR X3, [FP, #-32] // store X3
	
	ADD X0, X1, XZR // set X0 to visit
	SUBI X1, XZR, #1 // set X1 to -1
	BL find
	LDUR X0, [FP, #-8]
	LDUR X1, [FP, #-16]
	LSL X7, X7, #3 // X7*8
	ADD X7, X7, X1
	SUBI X12, XZR, #1 // constant -1
	STUR X12, [X7, #8] // store -1 in *(visit+find(visit, -1)+1)
	STUR X3, [X7, #0] // store loc in *(visit+find(visit, -1))
	LSL X7, X3, #3 // loc*8
	ADD X7, X0, X7 
	LDUR X12, [X7, #0] // load *(maze+loc)
	CMPI X12, #1 // check if equal to 1
	B.EQ rzdfs

	CMPI X12, #2 // check if *(maze+loc) equal to 2
	B.EQ r1dfs

	ADD X0, X2, XZR // store path in X0
	SUBI X1, XZR, #1 // set X1 to -1
	BL find
	LDUR X0, [FP, #-8]
	LDUR X1, [FP, #-16]
	LSL X7, X7, #3 // X7*8
	ADD X7, X7, X2
	SUBI X13, XZR, #1 // constant -1
	STUR X13, [X7, #8] // store -1 in *(path+find(path, -1)+1)
	STUR X3, [X7, #0] // store loc in *(path+find(path, -1))
	
	ADDI X12, XZR, #0 // possible = 0

	UDIV X13, X3, X4 // loc / width
	MUL X14, X13, X4 
	SUB X14, X3, X14 // X14 stores remainder value
	SUBI X15, X4, #1 // width - 1

	CMPI X13, #0 // check if loc/width = 0 (if equal skip to next if)
	B.EQ if1
	
	ADDI X16, X3, #0 // temp register to hold loc
	ADD X3, X2, XZR // X3 holds path
	SUB X2, X16, X4 // X2 = loc - width
	BL check
	LDUR X2, [FP, #-24] // load path back to X2
	LDUR X3, [FP, #-32] // load loc back to X3
	ADD X12, X7, XZR // possible = X7
	
if1:	
	CMPI X12, #0 // check if possible = 0 (true)
	B.NE if2
	CMPI X14, #0 // check if loc%width = 0 (if equal skip to next if)
	B.EQ if2

	SUBI X16, X3, #1 // temp register to hold loc - 1
	ADD X3, X2, XZR // X3 holds path
	ADDI X2, X16, #0 // X2 = loc - 1
	BL check
	LDUR X2, [FP, #-24] // load path back to X2
	LDUR X3, [FP, #-32] // load loc back to X3
	ADD X12, X7, XZR // possible = X7

if2:
	CMPI X12, #0 // check if possible = 0 (true)
	B.NE if3
	CMP X13, X15 // check if loc/width = width-1 (if equal skip to next if)
	B.EQ if3

	ADD X16, X3, X4 // temp register = loc + width
	ADD X3, X2, XZR // X3 holds path
	ADDI X2, X16, #0 // X2 = loc + width
	BL check
	LDUR X2, [FP, #-24] // load path back to X2
	LDUR X3, [FP, #-32] // load loc back to X3
	ADD X12, X7, XZR // possible = X7

if3:
	CMPI X12, #0 // check if possible = 0 (true)
	B.NE lastif
	CMP X14, X15 // check if loc%width = width-1 (if equal skip to next if)
	B.EQ lastif

	ADDI X16, X3, #1 // temp register = loc + 1
	ADD X3, X2, XZR // X3 holds path
	ADDI X2, X16, #0 // X2 = loc + 1
	BL check
	LDUR X2, [FP, #-24] // load path back to X2
	LDUR X3, [FP, #-32] // load loc back to X3
	ADD X12, X7, XZR // possible = X7

lastif:
	CMPI X12, #0 // check if possible = 0 (true)
	B.NE r1dfslast // branch to return 1

	ADD X0, X2, XZR // store path in X0
	SUBI X1, XZR, #1 // set X1 to -1
	BL find
	LDUR X0, [FP, #-8]
	LDUR X1, [FP, #-16]
	SUBI X7, X7, #1 // subtract 1 from X7
	LSL X7, X7, #3 // X7*8
	ADD X7, X7, X2
	SUBI X13, XZR, #1 // constant -1
	STUR X13, [X7, #0] // store -1 in *(path+find(path, -1)-1)

rzdfs:
	ADDI X7, XZR, #0 // return 0
	B deallocatedfs

r1dfs:
	ADD X0, X2, XZR // store path in X0
	SUBI X1, XZR, #1 // set X1 to -1
	BL find
	LDUR X0, [FP, #-8]
	LDUR X1, [FP, #-16]
	LSL X7, X7, #3 // X7*8
	ADD X7, X7, X2
	SUBI X13, XZR, #1 // constant -1
	STUR X13, [X7, #8] // store -1 in *(path+find(path, -1)+1)
	STUR X3, [X7, #0] // store loc in *(path+find(path, -1))

r1dfslast:
	ADDI X7, XZR, #1 // return 1

deallocatedfs:
	LDUR X3, [FP, #-32] 
	LDUR X2, [FP, #-24]
	LDUR X1, [FP, #-16]
	LDUR X0, [FP, #-8]
	LDUR LR, [FP, #0]
	LDUR FP, [SP, #0]
	ADDI SP, SP, #48
	BR LR


////////////////////////
//                    //
//   possibleStarts   //
//                    //
////////////////////////
possibleStarts:
	// input:
	//  X0: Pointer to the maze array.
	//	X1: Pointer to the visit array.
	//	X2: Pointer to the path array.
	//	X3: The starting location(place).
	//	X4: The width of the maze.
	// output:
	//	X7: The number of different possible starting point.
	
	SUBI SP, SP, #48
	STUR FP, [SP, #0]
	ADDI FP, SP, #40
	STUR LR, [FP, #0]
	STUR X0, [FP, #-8] // store X0
	STUR X1, [FP, #-16] // store X1
	STUR X2, [FP, #-24] // store X2
	STUR X3, [FP, #-32] // store X3

	ADDI X8, XZR, #0 // count = 0
	MUL X9, X4, X4 // width * width
	CMP X3, X9 // 
	B.GE retcount // check if loc >= width^2
	UDIV X17, X3, X4 // row = loc / width
	MUL X18, X17, X4 
	SUB X18, X3, X18 // loc % width
	SUBI X19, X4, #1 // width - 1
	CMPI X17, #0
	B.EQ checkand
	CMP X17, X19
	B.EQ checkand
	CMPI X18, #0
	B.EQ checkand
	CMP X18, X19
	B.NE endstarts

checkand: 
	LSL X17, X3, #3 // loc * 8
	ADD X17, X17, X0 // maze + loc*8
	LDUR X17, [X17, #0] // load maze[loc]
	CMPI X17, #0
	B.NE endstarts

	SUBI X17, XZR, #1 // temp register to hold -1
	STUR X17, [X1, #0] // *(visited) = -1
	STUR X17, [X2, #0] // *(path) = -1
	BL dfs
	CMPI X7, #0
	B.EQ endstarts
	MOV X1, X2 // X1 = path
	MOV X2, X4 // X2 = width
	BL display
	LDUR X1, [FP, #-16]
	LDUR X2, [FP, #-24]
	ADDI X8, X8, #1

endstarts:
	ADDI X3, X3, #1 // loc + 1
	BL possibleStarts
	ADD X7, X7, X8
	B deallocatestarts

retcount:
	ADDI X7, X8, #0 // return count
	B deallocatestarts

deallocatestarts:
	LDUR X3, [FP, #-32] 
	LDUR X2, [FP, #-24]
	LDUR X1, [FP, #-16]
	LDUR X0, [FP, #-8]
	LDUR LR, [FP, #0]
	LDUR FP, [SP, #0]
	ADDI SP, SP, #48
	BR LR
