from pathlib import Path
import os

# made with ai to simply handle outputs

ROOT = Path(__file__).resolve().parent
TESTS_DIR = ROOT / "tests"
OUTPUT_NAMES = {"output.txt", "epic-output.txt"}
EXCLUDE_NAMES = {
    "input.txt", "Input.txt",}

EXCLUDE_FOLDERS = {
    "template-1", "template-2"
}

input_names = {
    
    "accounts.txt":"Accounts.txt",
    "application.txt":"Application.txt",
    "connections.txt":"Connections.txt",
    "jobs.txt":"Jobs.txt",
    "messages.txt":"Messages.txt",
    "profiles.txt":"Profiles.txt",
    
    "Accounts.txt":"Accounts.txt",
    "Application.txt":"Application.txt",
    "Connections.txt":"Connections.txt",
    "Jobs.txt":"Jobs.txt",
    "Messages.txt":"Messages.txt",
    "Profiles.txt":"Profiles.txt"
    }

def modify_condition(inital_file,new_file):
    output_str = f"""
           MOVE "{new_file}"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "{inital_file}" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE."""
    return output_str

def create_test(directory):
    
    test_output = f""""""
    
    for file in directory.iterdir():
        # any inputs we need to modify
        if file.is_file() and (file.name in input_names) and (file.name not in EXCLUDE_NAMES):
            
            mod_condition = modify_condition( input_names[file.name],file.relative_to(ROOT))
            test_output += mod_condition
            
    test_output = f"""
      *    =============================================================
      
           MOVE "{directory.relative_to(ROOT)}"
                  TO WS-FOLDER.
           {test_output}
    
           PERFORM COUNTER-UPDATE.
    """
    #input()
    
    return test_output


def main():
    try:
        os.remove("final_output.txt")
    except Exception as e:
        print(e)
        
        
    
        
    # first step is to get an output file
    with open("final_output.txt","a+") as final_output:
        # iterate through each epic, tester, then the tests they wrote
        for epic_dir in sorted(TESTS_DIR.iterdir()):
            if (epic_dir.is_dir()):
                for tester_dir in sorted(epic_dir.iterdir()):
                    if (tester_dir.is_dir()):
                        for folder in tester_dir.iterdir():
                            if folder.is_dir() and folder.name not in EXCLUDE_FOLDERS:
                                # create a test using our naming conventions
                                try:
                                    final_output.write(create_test(folder))
                                except Exception as e:
                                    print(e)
    
    with open("test-main-constr.cob","w+") as cob_file:
        cob_file.writelines(open("test-main-first-half.txt","r+").readlines())
        cob_file.writelines(open("final_output.txt","r+").readlines())
        cob_file.writelines(open("test-main-second-half.txt","r+").readlines())
        
            
if __name__ == "__main__":
    main()