export PATH=$PATH:/opt/homebrew/bin/

LoginItems=`ls -d1 /Applications/*.app/Contents/Library/LoginItems/* \
~/Applications/*.app/Contents/Library/LoginItems/*`

echo "$LoginItems"|while read item;do
    echo $item
done
