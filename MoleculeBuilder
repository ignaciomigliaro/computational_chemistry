#! /usr/bin/env python
import random 
import math 
#In molecule builder 2.0 we have added more flexibility that alllows for the LA-LB distance to adjust depending if the code detects atoms from the substituents are too close. Other fixes have been implemented as shorter code. 
#The frame of reference has been fixed to an axis which makes the translation of the LBL easier. 
#In this version the mechanism is added to identify atomic distances and adjust the LA-LB length 

def permutation():
	#calculated permutations
	p=1000
	np=p/1
	x=0
	input_vector=open("inputvector","w")
	for permutation in range(np): 
		x=x+1
		LA= random.randint(1,10)
		if LA <= 5: 
			LAL=random.randint(1,9)
		if LA > 5: 
			LAL=random.randint(10,14)
		LB=random.randint(1,10)
		if LB <= 5: 
			LBL=random.randint(1,9)
		if LB > 5:
			LBL=random.randint(10,15)
		print >> input_vector, LA,LAL,LB,LBL
def write_input(file1,file2,file3,file4,file5,file6): 
	inp_vect=open(file1,'r')
	LA=open(file2,'r')
	LAL=open(file3,'r')
	LB=open(file4,'r')
	LBL=open(file5,'r')
	solv=open(file6,'r')
	i=0
	ivect={}
	for line in inp_vect: 
		ls=line.split()
		i=i+1
		ivect[i,1]=ls[0]
		ivect[i,2]=ls[1]
		ivect[i,3]=ls[2]
		ivect[i,4]=ls[3]
	dir="/home/im0225/Scripts/neuralnetworks4/molecule/gjf"

	for it in range(1,i+1):
		LA.seek(0)
		LAL.seek(0)
		LB.seek(0)
		LBL.seek(0)
		file=str(ivect[it,1])+"."+str(ivect[it,2])+"."+str(ivect[it,3])+"."+str(ivect[it,4])+".gjf"
		gjfile=dir+"/adduct/"+file
		gjfile_prod11=dir+"/prod11/"+file
		gjfile_prod12=dir+"/prod12/"+file
		gjfile_prod21=dir+"/prod21/"+file
		gjfile_prod22=dir+"/prod22/"+file
                chkfile=str(ivect[it,1])+"."+str(ivect[it,2])+"."+str(ivect[it,3])+"."+str(ivect[it,4])+".chk"
		prod11=open(gjfile_prod11,'w')
		prod12=open(gjfile_prod12,'w')
		prod21=open(gjfile_prod21,'w')
		prod22=open(gjfile_prod22,'w')
		adduct=open(gjfile,'w')
		#adduct2=open(gjfile,'r')
                opt="# opt=(Loose,Maxcycles=200,recalcfc=50)"
                dft="wb97xd"
                basis="def2svp"
                solvent="scrf=(smd,solvent=acetonitrile)"
                extra=" "
		for i in (adduct,prod11,prod12,prod21,prod22):
			print >> i, "%nproc=8"
                	print >> i, "%mem=16gb"      
                	print >> i, "%chk="+chkfile
			print >> i, opt,dft,basis,solvent,extra
			print >> i, "   "
			print >> i, "title"
			print >> i, " " 
		print >> adduct, "0 1" 
		print >> prod11, "-1 1" 
		print >> prod12, "1 1" 
		print >> prod21, "-1 1"
		print >> prod22, "1 1 " 
		for line2 in LA:
			ls2=line2.split()
			if ls2[0] == ivect[it,1]:
				acid=ls2[1]
		for i in (adduct,prod11,prod21):
			print >> i, str(acid), "-1.300000000 0.000000000 0.000000000"
		print >> prod11, "6 0.200000000 0.000000000 0.000000000"
		print >> prod11, "1 0.599020000 -0.008907000 1.020692000"
		print >> prod11, "1 0.599020000 -0.879491000 -0.518060000"
		print >> prod11, "1 0.599020000 0.888399000 -0.502632000"
		print >> prod21, "1 0.000000000  0.000000000  0.000000000"
		#for linelb in LB:
		#	lslb=linelb.split()
		#	if lslb[0] == ivect[it,3]:
		#		base=lslb[1]
		#for i in (adduct,prod12,prod22):
		#print >> i, str(base), "1.300000000 0.000000000 0.000000000"
		#print >> prod12,"1 -.300000000 0.000000000 0.000000000" 
		for line3 in LAL:
			ls3=line3.split()
			if len(ls3) == 2:
				if ls3[0] == ivect[it,2]:
					line3=LAL.next()
					ls3=line3.split()
				while not len(ls3) == 2: 
					ls3=line3.split()
					if len(ls3) == 4: 
						atoms,coordx,coordy,coordz=ls3[0],ls3[1],ls3[2],ls3[3]
						for i in adduct,prod11,prod21: 
							print >> i, atoms,coordx,coordy,coordz
						
					else:
						break 
		  			line3=LAL.next()
		 
#### mechanism to identify atom distances in adduct ###
		c=0
		lbl={}
		for linelbl in LBL:
        		ls5=linelbl.split()
        		if len(ls5) == 2:
                		if ls5[0] == ivect[it,4]:
                        		linelbl=LBL.next()
                        		ls5=linelbl.split()
                		while not len(ls5) == 2:
                      			c=c+1
                      			ls5=linelbl.split()
                      			if len(ls5) == 4:
						atoms2,coordx2,coordy2,coordz2=ls5[0],ls5[1],ls5[2],ls5[3]
                                		lbl[c,0]=(ls5[0])
                                		lbl[c,1]=float(ls5[1])
                                		lbl[c,2]=float(ls5[2])
                                		lbl[c,3]=float(ls5[3])
						for i in prod12,prod22: 
							print >> i, atoms2,coordx2,coordy2,coordz2
                      			else:
                                		break
                      			linelbl=LBL.next()
		d=.99
	        LB_new=1.30000	
		restart = True
		count=0
		adduct.close()
		adduct=open(gjfile,'r')
		for line in adduct:
        		restart = True
        		ls=line.split()
        		if len(ls) == 4:
                		ls=line.split()
                		if len(ls) == 4:
                        		x1=float(ls[1])
                        		y1=float(ls[2])
                        		z1=float(ls[3])
                        		while restart:
                                		count=count+1
						for x in range(1,c):
							d1=(x1-lbl[x,1])**2+(y1-lbl[x,2])**2+(z1-lbl[x,3])**2
                                        		d=math.sqrt(d1)
                                        		if d < 1.5:
                                                		x=1
								LB_new=LB_new+0.5
                                                		for b in range(1,c):
                                                        		lbl[b,1]=lbl[b,1]+0.5
                                                		break
						if d >= 1.5:
							restart = False
		adduct.close()
		adduct=open(gjfile,'a')
		for z in range(1,c): 
			print >> adduct, lbl[z,0],lbl[z,1],lbl[z,2],lbl[z,3]
		#	print lbl[z,0],lbl[z,1],lbl[z,2],lbl[z,3]
		#print "coord"
		for linelb in LB:
                        lslb=linelb.split()
                        if lslb[0] == ivect[it,3]:
                                base=lslb[1]
                		for i in (prod12,prod22):
				 	print >> i, str(base), "1.300000000 0.000000000 0.000000000"
				print >> prod12, "1 -.300000000 0.000000000 0.000000000"
				print >> prod22, "6 -0.141961447 0.035951044 -0.283469061"
				print >> prod22, "1 -0.336699194 0.036805338 -1.361979578"
				print >> prod22, "1 -0.654406472 -0.833518266 0.143767123"
				print >> prod22, "1 -0.609006112 0.933842950 0.136968898"
				print >> adduct, str(base), LB_new," 0.000000000 0.000000000"
### This is for the products 
		for i in adduct,prod11,prod12,prod21,prod22:
			print >> i, " " 
			i.close()
	
		
LB_ligands="/home/im0225/Scripts/neuralnetworks4/molecule/LB_ligands"
LA_ligands="/home/im0225/Scripts/neuralnetworks4/molecule/LA_ligands"
LA="/home/im0225/Scripts/neuralnetworks4/molecule/LA"
LB="/home/im0225/Scripts/neuralnetworks4/molecule/LB"
solv="/home/im0225/Scripts/neuralnetworks3/molecule/solvents"
input="/home/im0225/Scripts/neuralnetworks4/inputvector"
#permutation()	
write_input(input,LA,LA_ligands,LB,LB_ligands,solv)



