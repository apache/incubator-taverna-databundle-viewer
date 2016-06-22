#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

class DataBundlesController < ApplicationController
  before_action :set_data_bundle, only: [:show, :edit, :update, :destroy]

  # GET /data_bundles
  def index
    if user_signed_in?
      @data_bundles = current_user.databundles.page(params[:page])
      @data_bundle = DataBundle.new
    end
  end

  # GET /data_bundles/1
  # GET /data_bundles/1.json
  def show
    @data_bundle = @data_bundle.decorate
    respond_to do |format|
      format.html
      # format.json { render json: @data_bundle.to_json }
      format.json { render :json => {:workflow => @data_bundle.to_dataHashObject,
                                     :provenance =>  @data_bundle.provenanceMain } }
    end
  end

  # GET /data_bundles/1/edit
  def edit
    redirect_to data_bundles_path,  notice: "Success"
  end

  # POST /data_bundles
  def create
    @data_bundle = current_user.databundles.new(data_bundle_params)

    if @data_bundle.save
      redirect_to @data_bundle, notice: 'Data bundle was successfully created.'
    else
      render :edit
    end
  end

  # PATCH/PUT /data_bundles/1
  def update
    if @data_bundle.update(data_bundle_params)
      redirect_to @data_bundle, notice: 'Data bundle was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /data_bundles/1
  def destroy
    @data_bundle.destroy
    redirect_to data_bundles_url, notice: 'Data bundle was successfully destroyed.'
  end

  def redirectToLogin
    redirect_to new_user_session_path, notice: 'Data bundle was successfully created.'
  end
  helper_method :redirectToLogin

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_data_bundle
    @data_bundle = DataBundle.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def data_bundle_params
    params.require(:data_bundle).permit(:file, :name)
  end  
end
