" allowling loading django as a additional syntax over things
if exists("b:current_syntax") && b:current_syntax != "django"
	unlet b:current_syntax
	source $VIMRUNTIME/syntax/django.vim
endif
