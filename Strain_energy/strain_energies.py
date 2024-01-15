#! /usr/bin/env python
import random
import math
import os
import subprocess
import time



def readout(filename):
	hd=open(filename,'r')
	coordx=[]
	coordy=[]
	coordz=[]
	atoms=[]
	geometry={}
	imol=0
	energy=0.0
	natoms=0
	for line in hd: 
		ls=line.split()
		if line.strip() in ("Input orientation:", "Standard orientation:"):
			for ii in range(4):hd.next()
			natoms=0
			atoms=[]
			coordx=[]
			coordy=[]
			coordz=[]
			line=hd.next()
			while not line.startswith("---------------"):
				ls = line.split()
				if (len(ls) == 6 and ls[0].isdigit() and ls[1].isdigit() and ls[2].isdigit()):
					atoms.append(int(ls[1]))
					coordy.append(float(ls[3]))
					coordx.append(float(ls[4]))
					coordz.append(float(ls[5]))
					natoms=natoms+1
				else:
					break
				line=hd.next()
	for iatoms in range(len(coordx)):
		geometry[iatoms,0] = atoms[iatoms]
		geometry[iatoms,1] = coordx[iatoms]
		geometry[iatoms,2] = coordy[iatoms]
		geometry[iatoms,3] = coordz[iatoms]
	return (geometry,natoms)

def strain_geometry(geometry,natoms):
	geometry_s={}
	n2atoms=0
	for iatoms in range(natoms):
		if geometry[iatoms,0] == 7:
			x1=geometry[iatoms,1]
			y1=geometry[iatoms,2]
			z1=geometry[iatoms,3]
	for iatoms in range(natoms):
		if geometry[iatoms,0] == 1: 
			D=float(math.sqrt((x1-geometry[iatoms,1])**2+(y1-geometry[iatoms,2])**2+(z1-geometry[iatoms,3])**2))
			if D > 1.2 and geometry[iatoms,0] == 1:
				n2atoms=n2atoms+1
				geometry_s[n2atoms,0] = geometry[iatoms,0]
				geometry_s[n2atoms,1] = geometry[iatoms,1]
				geometry_s[n2atoms,2] = geometry[iatoms,2]
				geometry_s[n2atoms,3] = geometry[iatoms,3]
	for iatoms in range(natoms):
		if geometry[iatoms,0] == 6:
				n2atoms=n2atoms+1
				geometry_s[5,0] = geometry[iatoms,0]
				geometry_s[5,1] = geometry[iatoms,1]
				geometry_s[5,2] = geometry[iatoms,2] 
				geometry_s[5,3] = geometry[iatoms,3]
		#for iatoms in range(n2atoms):
	#	print geometry_s[iatoms,0], geometry_s[iatoms,1], geometry_s[iatoms,2], geometry_s[iatoms,3]
	return geometry_s,n2atoms

def write_strain(geometry_s,outfile,n2atoms):
	infile = outfile.split(".out")
	gjfname = infile[0]+"_strain.gjf"
	outname = infile[0]+"_strain.out"
	rmgjf = "rm -rf "+gjfname
	os.system(rmgjf)
	chkname = infile[0]+".chk"
	open_new=open(gjfname,"w")
	print >> open_new, "%nproc=8"
	print >> open_new, "%mem=16gb"
	print >> open_new, "%chk="+chkname
	print >> open_new, "# wb97xd def2tzvpp scrf=(smd,solvent=acetonitrile)"
	print >> open_new, "       " 
	print >> open_new, infile[0]
	print >> open_new, "      " 
	print >> open_new, "0 1" 
	for iatoms in range(1,n2atoms+1):
		if n2atoms > 0: 
			print >> open_new, geometry_s[iatoms,0], geometry_s[iatoms,1], geometry_s[iatoms,2], geometry_s[iatoms,3]
	print >> open_new, "              "
	sendg09="g09 "+str(gjfname)
	return gjfname,outname
		
#def get_energy(output):
##	ENERGY=0.0
#	for line in output:
#		ENERGY=0.0
#		ls=line.split()
#		if "SCF Done" in line:
#			ENERGY=float(line.split()[4])
#	return(ENERGY)
		
	
#this was a failed attempt to get the variables from bash terminal with pythons script, easier to do it the other way around
#p=subprocess.Popen(['ls'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
#out,err = p.communicate()
#ls=out.split()
#ls2=[]
#for i in range(len(ls)): 
#	ls2=ls[i].split(".")
#	if ls2[1] == "out": 
#		outfile=ls2[0]+".out"
#	        a,b=readout(outfile)
#		c,d=strain_geometry(a,b) 	
#		e=write_strain(c,outfile,d)
#		send="g09 "+str(e)
#		#os.system(send)
#		print send 

file="~~~"
a,b=readout(file)
c,d=strain_geometry(a,b)
e,f=write_strain(c,file,d)
send="g09 "+e
os.system(send)


