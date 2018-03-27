mkdir ruby-cucumber
cd ruby-cucumber
jerryhsieh@~/Developer/Web/Study/Web應用程式開發/ruby-cucumber$ rvm use ruby-2.4.2
jerryhsieh@~/Developer/Web/Study/Web應用程式開發/ruby-cucumber$ rvm --rvmrc --create 2.4.2@myapp_cucumber_example
cd ..
cd ruby-cucumber
#accept .rvmrc
#check .rvmrc
rvm info
emacs Gemfile
mkdir views
cucumber --init 
emacs views/layout.erb, views/index.erb, views/form.erb, views/thankyou.erb
emacs config.ru

shotgun to activate web

