import os
import sys
import re

def check_cost_center(terraform_dir):
    failed = False
    tf_files = [f for f in os.listdir(terraform_dir) if f.endswith('.tf')]
    
    if not tf_files:
        print("No .tf files found!")
        sys.exit(1)
    
    for tf_file in tf_files:
        filepath = os.path.join(terraform_dir, tf_file)
        print(f"\nChecking: {tf_file}")
        
        with open(filepath, 'r') as f:
            content = f.read()
        
        lines = content.split('\n')
        i=0
        found_resource = False

        while i < len(lines):
            line = lines[i].strip()
            match = re.match(r'\s*resource\s+"([^"]+)"\s+"([^"]+)"', lines[i])
            if match:
                found_resources = True
                resource_type = match.group(1)
                resource_name = match.group(2)

                #ceo blok sa broj zagrada
                block_content = ""
                depth = 0
                while i < len(lines):
                    block_content += lines[i] + '\n'
                    depth += lines[i].count('{') - lines[i].count('}')
                    i += 1
                    if depth == 0 and block_content.strip():
                        break
                if resource_type in ['aws_route_table_association']:
                    print(f"{resource_type}.{resource_name} - Skipping CostCenter check for this resource type")
                    continue

                if 'CostCenter' in block_content:
                    print(f"{resource_type}.{resource_name} has CostCenter tag")
                else:
                    print(f"{resource_type}.{resource_name} is MISSING CostCenter tag!")
                    failed = True
            else:
                i += 1
        if not found_resources:
            print(f"  No resources found in {tf_file}")
    
    return failed


terraform_dir = sys.argv[1] if len(sys.argv) > 1 else "./terraform"

print("=" * 50)
print("CostCenter Tag Compliance Check")
print("=" * 50)

failed = check_cost_center(terraform_dir)

print("\n" + "=" * 50)
if failed:
    print("FAILED: Some resources are missing CostCenter tag!")
    sys.exit(1)
else:
    print("PASSED: All resources have CostCenter tag!")
    sys.exit(0)