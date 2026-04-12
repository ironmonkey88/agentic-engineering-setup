#!/usr/bin/env python3
"""
WWWarehouse: Worker Verification Utility (CP-002)
Standardizes the 'Qualified Worker' handshake.
"""

import os
import yaml
import sys

def verify_worker(mode_name):
    mode_path = f"factory/modes/{mode_name}/MODE.yaml"
    if not os.path.exists(mode_path):
        print(f"❌ Error: Mode definition not found at {mode_path}")
        return False

    with open(mode_path, 'r') as f:
        try:
            data = yaml.safe_load(f)
            content = yaml.safe_load(data['content'])
        except Exception as e:
            print(f"❌ Error parsing Mode YAML: {e}")
            return False

    required_skills = content.get('requiredSkills', [])
    objectives = content.get('objectives', [])

    print(f"🔍 Auditing Worker: {content.get('name', mode_name)}")
    print(f"🎯 Objectives: {', '.join(objectives) if objectives else 'None defined'}")
    
    missing_skills = []
    for skill in required_skills:
        skill_path = f"factory/skills/{skill}/SKILL.md"
        if not os.path.exists(skill_path):
            missing_skills.append(skill)
            print(f"  ❌ Missing Skill: {skill} (Path: {skill_path})")
        else:
            print(f"  ✅ Verified Skill: {skill}")

    if missing_skills:
        print(f"\n🚫 Handshake Failed: Worker is UNQUALIFIED. Please harvest required skills.")
        return False

    print(f"\n✅ Handshake Successful: Worker is QUALIFIED.")
    return True

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: verify_worker.py [mode_slug]")
        sys.exit(1)
    
    success = verify_worker(sys.argv[1])
    sys.exit(0 if success else 1)
