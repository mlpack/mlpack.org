import sys
import hashlib
import os
import datetime

if len(sys.argv) != 2:
    print("Usage: python scripts/update-website-release.py files/mlpack-x.x.x.tar.gz")
    exit(1)

filename = sys.argv[1]

# Generate hash for release archive.
print("File %s" % (sys.argv[1]))
with open(filename,"rb") as f:
  bytes = f.read()
  fileHash = hashlib.sha1(bytes).hexdigest()
print("File hash %s" % (fileHash))

# Extract version from archive name.
baseName = os.path.basename(filename)
baseName = baseName.partition('-')[2]
fileVersion = baseName.replace(".tar.gz", "")
print("File version %s" % (fileVersion))

# Get file size.
fileSize = format(os.path.getsize(filename) / 1000000, ".1f")
print("File size: %s" % (fileSize))

# Get file create date.
fileDate = os.stat(filename)
try:
  fileDate = fileDate.st_birthtime
except AttributeError:
  fileDate = fileDate.st_mtime

fileDate = datetime.datetime.fromtimestamp(fileDate).strftime('%B %d, %Y')
print("File date: %s" % (fileDate))

# Read the index.html file.
with open("html/index.html") as f:
  indexContent = f.read()

# Replace current version with the new version.
downloadStart = indexContent.find('<a id="download-archive" href="')
downloadEnd = indexContent.find('">', downloadStart)
if downloadStart > 0 and downloadEnd > 0:
  indexContent = indexContent.replace(indexContent[downloadStart + 31:downloadEnd], filename)

# Replace current version with the new version.
versionStart = indexContent.find("<span>Version ")
versionEnd = indexContent.find("</span>", versionStart)
if versionStart > 0 and versionEnd > 0:
  indexContent = indexContent.replace(indexContent[versionStart + 14:versionEnd], fileVersion)

# Replace current file size with the new file size.
sizeStart = indexContent.find('<span id="file-size">')
sizeEnd = indexContent.find("</span>", sizeStart)
if sizeStart > 0 and sizeEnd > 0:
  indexContent = indexContent.replace(indexContent[sizeStart + 21:sizeEnd], str(fileSize) + "MB")

# Replace current file date with the new file date.
dateStart= indexContent.find('<span id="file-date">')
dateEnd = indexContent.find("</span>", dateStart)
if dateStart > 0 and dateEnd > 0:
  indexContent = indexContent.replace(indexContent[dateStart + 21:dateEnd], fileDate)

# Replace current hash with the new hash.
hashStart = indexContent.find("<span>SHA-1 Checksum: ")
hashEnd = indexContent.find("</span>", hashStart)
if hashStart > 0 and hashEnd > 0:
  indexContent = indexContent.replace(indexContent[hashStart + 22:hashEnd], fileHash)

with open("html/index.html", "w") as f:
  f.write(indexContent)

# Read the quickstart.html file.
with open("html/getstarted.html") as f:
  quickstartContent = f.read()

# Replace the built version.
builtStart = quickstartContent.find('<a id="built-source" href="https://www.mlpack.org/doc/mlpack-')
builtEnd = quickstartContent.find("/doxygen/", builtStart)
if builtStart > 0 and builtEnd > 0:
  quickstartContent = quickstartContent.replace(quickstartContent[builtStart + 61:builtEnd], fileVersion)

with open("html/getstarted.html", "w") as f:
  f.write(quickstartContent)

