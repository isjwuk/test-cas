#Powershell Function to Validate a CAS
#What is a CAS? - See http://www.cas.org/content/chemical-substances/faqs 

Function Test-CAS {
[cmdletbinding()]
Param (
[string]$CASNumber
)
    Process {
     Try {
            $CASNumber = $CASNumber.Trim()
            #A CAS Registry Number includes up to 10 digits which are separated into 3 groups by hyphens. 
            #The first part of the number, starting from the left, has 2 to 7 digits;
            #the second part has 2 digits. The final part consists of a single check digit.
            If ($CASNumber.Length -lt 1 -Or $CASNumber.Contains("-") -eq $False) { Return $False }
            #Get Position of first hyphen and text of first section
            $nFirstHyphen  = $CASNumber.IndexOf("-")
            $FirstSection  = $CASNumber.Substring(0,$nFirstHyphen)
            If ($nFirstHyphen -gt 7 -Or $nFirstHyphen -lt 2) {Return  $False} #First section is not 2 to 7 digits
            If (($FirstSection.Trim() -match "^[-]?[0-9.]+$" ) -eq $False) { Return $False} #First Section is not a number
            If ($CASNumber.substring( $nFirstHyphen + 2).Contains("-") -eq $False) { Return $False} # No Second Hyphen
            #Get Position of second hyphen and text of second Section
            $nSecondHyphen  = $CASNumber.IndexOf("-", $nFirstHyphen + 1)
            $SecondSection = ($CASNumber.Substring($nFirstHyphen + 1, $nSecondHyphen - $nFirstHyphen - 1))
            If (($SecondSection.Trim() -match "^[-]?[0-9.]+$" ) -eq $False) { Return $False} #Second Section is not a number
            #Get Checksum
            $Checksum = $CASNumber.Substring($CASNumber.Length - 1)
            If ($FirstSection + "-" + $SecondSection + "-" + $Checksum -ne $CASNumber) { Return $False } #Not formatted right
            If (($Checksum.Trim() -match "^[-]?[0-9.]+$" ) -eq $False){Return $False} #CheckSum Digit is not a number
            $nChecksum =[Single]$Checksum
            #Create the equation
            $C =[char]" "
            $nNumerator = 0
            $i = $FirstSection.Length + $SecondSection.Length
            ForEach ($C In $FirstSection + $SecondSection)
            {
                $nNumerator = $nNumerator + $i * [single]$C
                $i = $i - 1
            }
            #Run the equation
             $nResult  = ($nNumerator / 10 - [int]($nNumerator / 10)) * 10
            #Check Checksum is correct
            If ($nResult = $nChecksum)
            {
                Return $True
            }Else{
                Return $False
            }
        } Catch {
            Return "$False #Something went wrong. Boo."
        }

    }
}


#Test Data
"Test Data- checking test-CAS, a Powershell Function to Validate a CAS Number"
"50-08-2 is Caffeine and Should return 'True'"
Test-CAS 58-08-2 
"50-08-99 is invalid and Should return 'False'"
Test-CAS 58-08-99 
