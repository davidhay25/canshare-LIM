//Profiles for sarcoma grading (as an example)
//Note that mCode has the concept of grading as well - need
//to check that we align...


//------- create a profile with all the common constraints for grading observations. 
//tumour specific profiles will inherit from this

Profile: Grading
Parent: Observation     
Description: "The base profile for grading"

* subject 1..1

//--------- Create a profile for Sarcoma grading. Inherits from 
Profile: SarcomaGrading
Parent: Grading     
Description: "The grading for a Sarcoma"

* code = $unknownSystem#grading    //the real snomed code goes here

//Set up the slicing. The same config will be used in many profiles
//so create as a reusable ruleset
* insert SliceReferenceOnProfile(hasMember)

//specify the 2 observations we want. Others are allowed
//as the slicing is open
* hasMember contains
    mitoticCount 1..1 and
    percentNecrosis 1..1

//specify the profiles for each slice
* hasMember[mitoticCount] only Reference(MitoticCountObs) 
* hasMember[percentNecrosis] only Reference(PercentNecrosis) 

* value[x] only CodeableConcept
//* valueCodeableConcept from valueSetOfSarcomaGrades

//-------- Create a profile for the mitotic count
Profile: MitoticCountObs
Parent: Observation
Description: "The mitotic count"

* code = $unknownSystem#mitoticcount    //the real snomed code goes here
* value[x] only integer         //only integer is supported as a value type

//---------- Create a profile for the %necrosis
Profile: PercentNecrosis
Parent: Observation
Description: "The percent necrosis"

* code = $unknownSystem#percentnecrosis    //the real snomed code goes here
* value[x] only integer     //only integer is supported as a value



// ======== examples to test profiless

Instance: samplePatient
InstanceOf: Patient
Title: "Sample patient"
Usage: #example

* name.text = "John Doe"

//example basic observation
Instance: obs1
InstanceOf: Observation
Title: "height"
Usage: #example

* status = #final
* code = $unknownSystem#height 
* valueInteger = 34

//example mitotic count observation
Instance: mitoticCount1
InstanceOf: MitoticCountObs
Title: "Mitotic count 40"
Usage: #example

* status = #final
* code = $unknownSystem#mitoticcount  
* valueInteger = 40

//example percentnecrosis
Instance: percentNecrosis1
InstanceOf: PercentNecrosis
Title: "Percent necrosis 10"
Usage: #example

* status = #final
* code = $unknownSystem#percentnecrosis  
* valueInteger = 10

//the actual grade

Instance: sarcomaGrade1
InstanceOf: SarcomaGrading
Title: "Sarcoma grading example"
Usage: #example

* status = #final
* subject = Reference(samplePatient)

* hasMember[+] = Reference(mitoticCount1)
* hasMember[+] = Reference(percentNecrosis1)



// ======= ruleset

RuleSet: SliceReferenceOnProfile(path)
* {path} ^slicing.discriminator.type = #profile
* {path} ^slicing.discriminator.path = "$this.resolve()"
* {path} ^slicing.rules = #open
* {path} ^slicing.description = "Slicing based on profile conformance of the referenced resource."
