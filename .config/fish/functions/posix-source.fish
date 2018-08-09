function posix-source
	for i in (cat $argv)
		set arr (echo $i |tr = \n)
  		set -x $arr[1] $arr[2]
	end
end
