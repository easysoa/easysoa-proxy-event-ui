class NuxeotokensController < ApplicationController
  # GET /nuxeotokens
  # GET /nuxeotokens.json
  def index
    @nuxeotokens = Nuxeotoken.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nuxeotokens }
    end
  end

  # GET /nuxeotokens/1
  # GET /nuxeotokens/1.json
  def show
    @nuxeotoken = Nuxeotoken.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nuxeotoken }
    end
  end

  # GET /nuxeotokens/new
  # GET /nuxeotokens/new.json
  def new
    @nuxeotoken = Nuxeotoken.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nuxeotoken }
    end
  end

  # GET /nuxeotokens/1/edit
  def edit
    @nuxeotoken = Nuxeotoken.find(params[:id])
  end

  # POST /nuxeotokens
  # POST /nuxeotokens.json
  def create
    @nuxeotoken = Nuxeotoken.new(params[:nuxeotoken])

    respond_to do |format|
      if @nuxeotoken.save
        format.html { redirect_to @nuxeotoken, notice: 'Nuxeotoken was successfully created.' }
        format.json { render json: @nuxeotoken, status: :created, location: @nuxeotoken }
      else
        format.html { render action: "new" }
        format.json { render json: @nuxeotoken.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nuxeotokens/1
  # PUT /nuxeotokens/1.json
  def update
    @nuxeotoken = Nuxeotoken.find(params[:id])

    respond_to do |format|
      if @nuxeotoken.update_attributes(params[:nuxeotoken])
        format.html { redirect_to @nuxeotoken, notice: 'Nuxeotoken was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @nuxeotoken.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nuxeotokens/1
  # DELETE /nuxeotokens/1.json
  def destroy
    @nuxeotoken = Nuxeotoken.find(params[:id])
    @nuxeotoken.destroy

    respond_to do |format|
      format.html { redirect_to nuxeotokens_url }
      format.json { head :no_content }
    end
  end
end
