#!/usr/bin/env python
# This marvelous peace of modern and advanced
# software creates a gitosis repo, initializes
# and pushes it

# Syntax 
# mkgitosis <ProjectName> ([<PeopleWithAccess>] || [<PeopleToGrantAccess>:<PathToPubKey>])

import subprocess
import sys
import os.path

gitosis_admin = os.path.expanduser('')
gitosis_host = ''
project_name = ""
people_with_access = []
people_to_grant_access = {}

def mkproject():
  """
  # mkdir <project_name>
  # cd <project_name>
  # git init
  # create file README.txt
  #   open file README.txt 
  #   write "Project <project_name> description:"
  # git add .
  # gitCommit(<PathToProjectName>, commit_message="Initial stuff.")
  # gitAddRemoteAndPush(<gitosis-host>, <project_name>)
  """
  run("mkdir %s" % project_name)
  run("cd %s && git init" % project_name)
  append("README.txt", message="Project %s description" % project_name)
  run("cd %s && git add ." % project_name)
  gitCommit(project_name, commit_message="Initial stuff.")
  gitosisAddRepo()
  gitAddRemoteAndPush(gitosis_host, project_name)

def gitCommit(project_name, commit_message):
  """
  # cd <project_name>
  # git commit -a -m commit_message
  """
  run("cd %s && git commit -m %s" % (project_name, commit_message))

def gitPush(directory):
  """
  # cd <directory>
  # git push
  """
  run("cd %s && git push" % project_name)

def gitAddRemoteAndPush(host, project_name):
  """
  # git remote add origin git@<host>:<project_name>.git
  # git push origin master:refs/heads/master
  """
  run("git remote add origin git@%s:%s.git" %  (host, project_name))
  run("git push origin master:refs/heads/master")

def gitosisAddUsers():
  """
  # cd gitosis-admin
  # For each user in <people_to_grant_access>
  #   cp key keydir/<PersonName>.pub
  #   git add keydir/<PersonName>.pub 
  # Add to <people_with_access>
  """
  gitosis_key_dir = os.path.join(gitosis_admin, 'keydir') 
  for person, key in people_to_grant_access:
    run("cp %s %s/%s.pub" % (key, gitosis_key_dir, person))
    run("git add %s/%s.pub" % (gitosis_key_dir, person))
  
  people_with_access.append(person)


def gitosisAddRepo():
  """
  # cd gitosis-admin
  # Open file gitosis.conf
  # Append to end of file:
  #   [group <project_name>]
  #   writable = <project_name>
  #   members = <PeopleWithAccess>
  # gitCommit(<gitosis-admin>, commit_message="Added repo <ProjectName>.")
  # gitPush(<gitosis-admin>)
  """
  conf_file = os.path.join(gitosis_admin, 'gitosis.conf')
  
  group = """\

  [group %s]
  writable = %s
  members = %s
  """ % ( project_name, project_name, ' '.join(people_with_access) )

  append(conf_file, group)
  gitCommit(gitosis_admin, commit_message="Added repo %s." % project_name)
  gitPush(gitosis_admin)

def run(command):
  """
  Wrapper for python subprocess,
  runs a command and returns it's output
  """
  print("[Running] " + command)
  
  out_stream = subprocess.PIPE
  err_stream = subprocess.PIPE

  try:
    p = subprocess.Popen(command, shell=True, stdout=out_stream, stderr=err_stream)
    (stdout, stderr) = p.communicate()
 
  finally:
    if p.returncode != 0:
      print("Command %s failed with return code %s" % (command, p.returncode))
      sys.exit()
    else:
      print("done.")

def append(filename, message):
  """
  Creates a file if it does not exist
  and appends message to it
  """
  # if exists and is a file
  if os.path.isfile(filename):
    f = open(filename, 'a')
  else:
    f = open(filename, 'w')

  try:
    f.write(message)
  finally:
    f.close()


if __name__ == '__main__':
  if len(sys.argv) < 2:
    print("Usage is: mckgitosisrepo <ProjectName> ([<User> || <User>:<PathToUserKey>]")
  else:
    project_name = sys.argv[1] 
    
    for arg in sys.argv[1::]:
      parsed = arg.split(':')  
      if len(parsed) > 2:
        print("Usage is: mckgitosisrepo <ProjectName> ([<User> || <User>:<PathToUserKey>]")
      elif len(parsed) == 1:
        people_with_access.append(parsed[0])
      elif len(parsed) == 2:
        user = parsed[0]
        key_path = parsed[1]
        people_to_grant_access[user] = key_path 
        
      if len(people_to_grant_access) > 0:
        gitosisAddUsers()
  
  mkproject()
