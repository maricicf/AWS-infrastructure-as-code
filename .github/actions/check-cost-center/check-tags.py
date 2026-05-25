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
        
        # svi blokovi
        resource_pattern = re.compile(
            r'resource\s+"([^"]+)"\s+"([^"]+)"\s+\{([^}]*(?:\{[^}]*\}[^}]*)*)\}',
            re.DOTALL
        )
        
        resources = resource_pattern.findall(content)
        
        if not resources:
            print(f"  No resources found in {tf_file}")
            continue
            
        for resource_type, resource_name, resource_body in resources:
            if 'CostCenter' in resource_body:
                print(f"{resource_type}.{resource_name} has CostCenter tag")
            else:
                print(f"{resource_type}.{resource_name} is MISSING CostCenter tag!")
                failed = True
    
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