class PoweruserController < ApplicationController

  before_filter :require_PowerUser_login

  layout 'securearea'

  def require_PowerUser_login
    if ((session[:user_id].nil?)||(session[:user_role_id].to_i!=1))
      flash[:error] = "You must be logged in as Power User to access this section"
      #redirect_to :controller => 'unsecurearea', :action => 'connexion'
      redirect_to :controller => :unsecurearea, :action => 'createconnexion' and return
    end
  end

  def newcustomjxpath

    if (params[:customjxpath].nil?)
      @jxpathc= Customjxpath.new
    else
      @jxpathc = Customjxpath.new(params[:customjxpath])
      if @jxpathc.valid?
        @jxpathc.save
        redirect_to :action => 'listcustomjxpath' and return
      else
        render 'newcustomjxpath' and return
      end
    end
    render 'newcustomjxpath' and return
  end

  def newtemplatejxpath
    @templatejxpath = Templatejxpath.new
    if (params[:templatejxpath].nil?)
      @templatejxpath= Templatejxpath.new
    else
      @templatejxpath = Templatejxpath.new(params[:templatejxpath])
      if @templatejxpath.valid?
        @templatejxpath.save
        redirect_to :action => 'listtemplatejxpath' and return
      else
        render 'newtemplatejxpath' and return
      end
    end
    render 'newtemplatejxpath' and return
  end

  def listtemplatejxpath
    @listtemplatejxpath = Templatejxpath.all
  end


  def listcustomjxpath
    @listcustomjxpath = Customjxpath.all
  end


  def edittemplatejxpath
    @templatejxpath = Templatejxpath.find(params[:templatejxpath].to_i)
  end

  def editcustomjxpath
    @customjxpath = Customjxpath.find(params[:customjxpath].to_i)
  end


  def updatetemplatejxpath
    @templatejxpath = Templatejxpath.new(params[:templatejxpath])

    value = params[:templatejxpath]['value']
    description = params[:templatejxpath]['description']
    id = params[:templatejxpath]['id'].to_i
    @templatejxpath = Templatejxpath.find(params[:templatejxpath]['id'].to_i)
    @templatejxpath.value= value
    @templatejxpath.description = description
    if @templatejxpath.valid?
      if @templatejxpath.save
        #if (@templatejxpath.update_attribute('value', value))&&(@templatejxpath.update_attribute('description', description))
        redirect_to :action => 'listtemplatejxpath' and return
      end
    else
      render 'edittemplatejxpath'
    end

  end

  def updatecustomjxpath
    @customjxpath = Customjxpath.new(params[:customjxpath])

    value = params[:customjxpath]['value']
    description = params[:customjxpath]['description']
    id = params[:customjxpath]['id'].to_i
    @customjxpath = Customjxpath.find(params[:customjxpath]['id'].to_i)
    @customjxpath.value= value
    @customjxpath.description = description
    if @customjxpath.valid?
      if @customjxpath.save
        #if (@templatejxpath.update_attribute('value', value))&&(@templatejxpath.update_attribute('description', description))
        redirect_to :action => 'listcustomjxpath' and return
      end
    else
      render 'editcustomjxpath'
    end

  end

  def deletejxpath
    if (!params[:customjxpath].nil?)
      @customjxpath = Customjxpath.find(params[:customjxpath])
      @customjxpath.destroy
      redirect_to :action => 'listcustomjxpath' and return
    end
    if (!params[:templatejxpath].nil?)
      @templatejxpath = Templatejxpath.find(params[:templatejxpath])
      @templatejxpath.destroy

      redirect_to :action => 'listtemplatejxpath' and return
    end
    render :text => 'Some problems ...', :status => '404'
  end



end
#if !@jxpathc.valid?
