# Process Killer Script for IOS

## Description
`prockiller-ios.sh` is an interactive Bash script designed to view, search, and kill processes easily by their names. It provides a user-friendly menu to display a full list of processes, search for processes using partial names, and terminate selected processes interactively.

---
## Features
- **Display Full Process List**: Shows all running processes with their PIDs and names.
- **Search Processes by Name**: Allows filtering processes by entering part of the process name.
- **Kill Processes**: Enables terminating processes interactively by selecting their number.
- **Error Handling**: Handles edge cases gracefully, such as invalid process selection.
---
## Usage
### Requirements
- **Bash Shell** (any POSIX-compliant environment)
- `ps` command for listing processes
- `awk` for text processing
- `kill` command for terminating processes
---
### Running the Script
Run the script with appropriate permissions, such as `sudo`:
```bash
sudo ./prockiller-ios.sh
```
---
### Menu Options
- **1. Display full process list**: View all processes with their respective IDs.
- **2. Search for a process by name**: Filter processes using part of their names.
- **3. Quit**: Exit the script cleanly.
---
### Example Execution
```bash
$ sudo ./prockiller-ios.sh
===================================
         PROCESS KILLER            
===================================
1. Display full process list
2. Search for a process by name
3. Quit
===================================
Choose an option: 2

Enter part of the process name to search: Viber
===================================
       SEARCH RESULTS: Viber       
===================================
No.   PID        Process Name       
1     12345      Viber
===================================
Enter the number to kill a process, or press Enter to return: 1

===================================
    Killing PID 12345...            
===================================
PID 12345 killed successfully.
```
---
## Author
- **Name**: Rosen Tsaryanski
---
## Version
- **Version**: 1.0
---
## License
This project is licensed under the MIT License.
