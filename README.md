# test-cas
Powershell function to check validity of a CAS number

What is a CAS? - See http://www.cas.org/content/chemical-substances/faqs - TL/DR- it's a number that identifies a chemical. If you don't know what one is already, you're probably not going to want to use this function.

## Example Usage
PS C:\> #Example of test-CAS.  
PS C:\> #This first one uses the CAS Number of Caffeine. This should return "true" as it is valid  
PS C:\> test-CAS 58-08-2  
True  
PS C:\> #This second example uses an invalid CAS and should return "false"  
PS C:\> test-CAS 58-08-99  
False  

