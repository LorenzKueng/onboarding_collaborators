********************************************************************************
*** SETUP — [Project Name]
*** Run this at the top of every do-file
********************************************************************************

*** === Each user sets this ===
if "`c(username)'" == "[your username]" {
    global ProjectX  "[path to project folder]"
}

*** === Derived globals (same for all users) ===
global raw        "$ProjectX/data/raw/"
global derived    "$ProjectX/data/_derived/"
global output     "$ProjectX/output/"
