class SubscriptionTypesController < ApplicationController
  # GET /subscription_types
  # GET /subscription_types.json
  def index
    @subscription_types = SubscriptionType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscription_types }
    end
  end

  # GET /subscription_types/1
  # GET /subscription_types/1.json
  def show
    @subscription_type = SubscriptionType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscription_type }
    end
  end

  # GET /subscription_types/new
  # GET /subscription_types/new.json
  def new
    @subscription_type = SubscriptionType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subscription_type }
    end
  end

  # GET /subscription_types/1/edit
  def edit
    @subscription_type = SubscriptionType.find(params[:id])
  end

  # POST /subscription_types
  # POST /subscription_types.json
  def create
    @subscription_type = SubscriptionType.new(params[:subscription_type])

    respond_to do |format|
      if @subscription_type.save
        format.html { redirect_to @subscription_type, notice: 'Subscription type was successfully created.' }
        format.json { render json: @subscription_type, status: :created, location: @subscription_type }
      else
        format.html { render action: "new" }
        format.json { render json: @subscription_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subscription_types/1
  # PUT /subscription_types/1.json
  def update
    @subscription_type = SubscriptionType.find(params[:id])

    respond_to do |format|
      if @subscription_type.update_attributes(params[:subscription_type])
        format.html { redirect_to @subscription_type, notice: 'Subscription type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscription_types/1
  # DELETE /subscription_types/1.json
  def destroy
    @subscription_type = SubscriptionType.find(params[:id])
    @subscription_type.destroy

    respond_to do |format|
      format.html { redirect_to subscription_types_url }
      format.json { head :no_content }
    end
  end
end
