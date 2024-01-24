files <- Sys.glob("*.csv")
#make an empty matrix or property and molecules

for (file in files) {
r2=regexpr("Max_Min",file)
r1=regexpr("_CoVarMat.csv",file)
property=substr(file,r2+8,r1-1)
if (r1>0){
property1=paste(property, "EigV1", sep="_")
property2=paste(property, "EigV2", sep="_")
property3=paste(property, "EigV3", sep="_")
molecule=substr(file,1,r2-2)
if (file.exists("molecules.txt")=="FALSE") {write(molecule, "molecules.txt", append = TRUE,  sep="\t")}
mpostn=length(grep(molecule,readLines("molecules.txt")))
if (mpostn==0) {write(molecule, "molecules.txt", append = TRUE,  sep="\t")}
if (file.exists("properties.txt")=="FALSE") {
write(property1, "properties.txt", append = TRUE,  sep="\t")
write(property2, "properties.txt", append = TRUE,  sep="\t")
write(property3, "properties.txt", append = TRUE,  sep="\t")
}
if (file.exists("properties.txt")=="TRUE") {
postn1=length(grep(property1, readLines("properties.txt")))
if (postn1==0){ 
write(property1, "properties.txt", append = TRUE,  sep="\t")
write(property2, "properties.txt", append = TRUE,  sep="\t")
write(property3, "properties.txt", append = TRUE,  sep="\t")
}
}
}
}

if (file.exists("mydata.csv")=="FALSE") {
mol_no<-length(readLines("molecules.txt"))
prop_no<-length(readLines("properties.txt"))
mydata <- matrix(rep("E",mol_no*prop_no), nrow=mol_no)
row_names=readLines("molecules.txt")
col_names=readLines("properties.txt")

#make a matix and rename rows columns
colnames(mydata, do.NULL = FALSE)
rownames(mydata, do.NULL = FALSE)
colnames(mydata) <- c(col_names)
rownames(mydata) <- c(row_names)
}


if (file.exists("mydata.csv")) {
molecules<-readLines("molecules.txt")
properties<-readLines("properties.txt")
mol_no<-length(readLines("molecules.txt"))
prop_no<-length(readLines("properties.txt"))
mydata_csv= read.csv("mydata.csv", sep=",", row.names=1)
mydata<- as.matrix(mydata_csv) 

#ADD ROW OR COLUMN IF REQUIRED
rows=nrow(mydata)
columns=ncol(mydata)
if (columns<mol_no) {
	for (molecule in molecules) {
		if (grepl(molecule,readLines("mydata.csv"))=="FALSE") {
		colnames(mydata)[ncol(mydata)]<-molecule
		mydata <- cbind(mydata, rep("E"))
		}
	}
}
if (rows<pro_no) {
	for (property in properties) {
		if (grepl(property,readLines("mydata.csv"))=="FALSE") {
		rownames(mydata)[nrow(mydata)]<-property
		mydata <- rbind(mydata, rep("E"))
		}
	}
}

}

i= 1
while(i <= nrow(mydata)) {
mol=rownames(mydata)[i]
j=1
    while(j <= ncol(mydata)) {
	if (mydata[i,j]=="E") {
	r3=regexpr("_EigV1",colnames(mydata)[j])
	prop= substr(colnames(mydata)[j],1,r3-1)
	if (prop!="") {
	file<- paste(mol,"Max_Min",prop,"CoVarMat.csv",sep ="_")
	if (file.exists(file)) {
	file1<- paste(mol,"Max_Min",prop,"EigenVect.csv",sep ="_")
	temp = read.csv(file, sep=",", row.names=1)
	temp1 <- as.matrix(temp) 
	mydata[i,j] <- eigen(temp1)$values[1]
	mydata[i,j+1] <- eigen(temp1)$values[2]
	mydata[i,j+2] <- eigen(temp1)$values[3]
	eig_vec <- eigen(temp1)$vectors
	write.csv(eig_vec, file1)
	}
	}
      }
         j <- j + 3
    }
i <- i + 1
}
write.csv(mydata, "mydata.csv")
