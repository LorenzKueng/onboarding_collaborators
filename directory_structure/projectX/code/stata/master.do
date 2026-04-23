********************************************************************************
*** MASTER DO-FILE — [Project Name]
********************************************************************************

if "`c(username)'" == "[your username]" {
    cd "[path to project]/code/stata"
}

do "00_setup.do"
* do "[next do-file].do"
