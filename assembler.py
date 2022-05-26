
import os
import re

#list of all file names in the directory with .asm extension
files =  [file.removesuffix(".asm") for file in os.listdir() if file.endswith(".asm")]

#Map of all our opcodes
opCodes = {
        #00000xx
        'NOP': '0000000', 
        'HLT': '0000001',
        'SETC': '0000010',
        #01xxxxx
        'NOT': '0100000',
        'INC': '0100001',
        'POP': '0100010',
        'IN': '0100011',
        'MOV': '0100100',
        'SWAP': '0100101',
        'ADD': '0100110',
        'SUB': '0100111',
        'AND': '0101000',
        'IADD': '0101001',
        #1xxxxxx
        'LDM': '1000000',
        'LDD': '1000001',
        #11xxxxx
        'STD': '1100000',
        'OUT': '1100001',
        'PUSH': '1100010',
        'JZ': '1100011',
        'JN': '1100100',
        'JC': '1100101',
        'JMP': '1100110',
        'CALL': '1100111',
        'RET': '1101000',
        'INT': '1101001',
        'RTI': '1101010',
        }
#map for our 8 registers
registers = {
    'R0': '000',
    'R1': '001',
    'R2': '010',    
    'R3': '011',
    'R4': '100',
    'R5': '101',
    'R6': '110',
    'R7': '111',
}

#List of 1 operand instructions
oneOperand =[
            'NOP',
            'HLT',
            'SETC',
            'NOT',
            'INC',
            'OUT',
            'IN',
            'PUSH',
            'POP',
            'RET',
            'RTI'
            ]

#List of Rdst and Rsrc Instructions
dstAndsrc = [
            'MOV',
            'SWAP',
            ]

#List of Rdst Rsrc1 and Rsrc2 Instructions
dstAndsrc1Andsrc2 = [
            'ADD',
            'SUB',
            'AND'
            ]

#List of imm only instructions
immOnly = [
        'JZ',
        'JN',
        'JC',
        'JMP',
        'CALL',
        ]
#Speciall Cases
#IADD 
#LDM
#LDD
#STD
#INT

Memory = {}

def WriteMemFile(outFile):
    #memory file has 2^20 lines, each line is 32 bits
    #if memory [line number] is not empty, write it to the file
    #else write 32 0's
    for i in range(0, 2**20):
        if Memory.__contains__(i):
            outFile.write(Memory[i])
            outFile.write('\n')
        else:
            outFile.write("00000000000000000000000000000000\n")
    
    return
    

def decode(instructions, outFile):
    PC = 0
    #loop over intructions untill you find '.ORG'
    #when found, add all the instructions after it to memory, untill you find another '.ORG' or end of list 
    #use the instructions[pc][1] as key for the memory
    
    while (PC < len(instructions)):
        if instructions[PC][0] == '.ORG':
            #set the key to the decimal value of the hexa read from instructions[pc][1]
            key = int(instructions[PC][1], 16)
            PC += 1
            while (PC < len(instructions) and instructions[PC][0] != '.ORG'):
                Memory[key] = ''
                # count = 0
                # for instruction in instructions[PC]:
                #     if opCodes.__contains__(instruction):
                #         Memory[key] += opCodes[instruction]
                #         count += 1
                #     elif registers.__contains__(instruction):
                #         Memory[key] += registers[instruction]
                #         count += 1
                #     else:
                #         if count == 0:
                #             #transform the hexa instruction to a 32 bit binary
                #             Memory[key] += bin(int(instruction, 16))[2:].zfill(32) 
                
                #if instruction[0] not in opCodes
                if not opCodes.__contains__(instructions[PC][0]):
                     Memory[key] += bin(int(instructions[PC][0], 16))[2:].zfill(32) 
                else:
                    if opCodes.__contains__(instructions[PC][0]):
                        Memory[key] += opCodes[instructions[PC][0]]
                    #if instructions[PC][0] in oneOperand:  
                    if instructions[PC][0] in oneOperand:
                            if len(instructions[PC]) > 1:
                                  Memory[key] += registers[instructions[PC][1]]
                    elif instructions[PC][0] in dstAndsrc:
                        Memory[key] += registers[instructions[PC][2]]
                        Memory[key] += registers[instructions[PC][1]]

                    
                PC +=1
                key +=1
               
        else:
            PC += 1
    
    
    for key in Memory:
        #if the Memory[key] is < 32 , add zeros to the right
        if len(Memory[key]) < 32:
            Memory[key] = Memory[key] + '0' * (32 - len(Memory[key]))  
        print(str(key) + ": " + Memory[key])
        
    #write the memory to the file
    WriteMemFile(outFile)
    return


def assemble(fileName):
    #print the file name
    print("Assembling: " + fileName)
    #open the file
    file = open(fileName + ".asm", "r")
    #open a file to write in assembler folder
    #if file doesn't exist, create it
    outFile = open("./assembler/" + fileName + ".txt", "w+")
    outFile.truncate()
    #read all the lines in the file , remove \n
    lines = [line.strip() for line in file.readlines()]
    #remove all \t from the lines
    lines = [line.replace("\t", "") for line in lines]
    
    temp = []
    #for each line in the file
    for line in lines:
        #split the line by #
        inst = line.split("#")
       
        #if there is nothing before the #, then it is a comment
        if len(inst[0]) == 0:
            continue
        #add inst[0] to the temp list
        temp.append(inst[0])
    #replace lines with new temp lines
    lines = temp
    #trim all the lines
    lines = [line.strip() for line in lines]
    #split lines by spaces
    lines = [line.split(" ") for line in lines]
    #print each line
    for line in lines:
        print(line)
    decode(lines, outFile)
    return 




for file in files:
    assemble(file)
