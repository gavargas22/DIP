% This code will apply certain enhancements to the NASA images.
% First, we select the image that we want to analyze through a dialog

% THE FOLLOWING IS THE CODE REQUIRED TO USE THE GUI SO IT IS NOT ESSENTIAL
% TO THE UNDERSTANDING OF THE ALGORITHM I USED TO MODIFY THE IMAGES.
function varargout = dip_toolbox(varargin)
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @dip_toolbox_OpeningFcn, ...
                       'gui_OutputFcn',  @dip_toolbox_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
end
function dip_toolbox_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);
end
function varargout = dip_toolbox_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;
end
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over save_image_button.
function save_image_button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to save_image_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes during object creation, after setting all properties.
function slope_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to slope (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
end

% --- Executes during object creation, after setting all properties.
function mid_point_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
end

% --- Executes during object creation, after setting all properties.
function normalization_value_CreateFcn(hObject, eventdata, handles)
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end
% //////////////////////////////////////////////////////////////////////



% ////////////////////////////////////////////////////
% IMAGE MANIPULATION FUNCTIONS

% Function to enhance the light pixels of the image selected
function enhance_image_with_contrast_stretching(data, slope_value, mid_point_value, display)
    stretched_contrast_image = 1./(1 + (mid_point_value./(data + eps)).^(slope_value));
    figure(display);
    imagesc(stretched_contrast_image);
    % Store the resulting image in case we want to save it.
    setappdata(display, 'stretched_image', stretched_contrast_image);
end

function perform_histogram_equalization_with_values(image_data, number_of_divisions, display)
    equalized_image = histeq(image_data, number_of_divisions);
    figure(display);
    imagesc(equalized_image);
    % Store the resulting image to save later.
    setappdata(display, 'stretched_image', equalized_image);
end

% ///////////////////////////////////////////////////


% FUNCTION EXECUTED TO SAVE THE IMAGE THAT WAS ENHANCED.
function save_image_button_Callback(hObject, eventdata, handles)
    % Open a dialog to save image.
    [filename, pathname] = uiputfile({'*.jpg;','JPG File';'*.*','All Files' },'Save Image');
    data_to_save = getappdata(handles.modified_picture_display, 'stretched_image');
    % Convert back to uint8
    resulting_image = im2uint8(data_to_save);
    imwrite(resulting_image, [pathname filename]);
    % Generate new statistics for image and save them as well
end
% //////////////////////////////////////////////////////////


% THIS FUNCTION IS THE ENTRY POINT WHERE THE IMAGE TO BE ENHANCED IS
% SELECTED.
function image_selector_button_Callback(hObject, eventdata, handles)
    % Open the file
    [FileName,PathName] = uigetfile('.JPG', 'Select the image to apply enhacements to.');
    % Get the useful full name and path of the image on a variable
    full_path_with_name = [PathName FileName];
    % Get information about the image in question, save it into useful
    % variables to use later.
    information_about_image = imfinfo(full_path_with_name);
    image_rows = information_about_image.Height;
    image_columns = information_about_image.Width;
    
    % I set a variable to the number of total items in the image for future
    % use.
    total_number_of_pixels = image_rows * image_columns;
    
    % Now open the image and put its data in a variable.
    image_data = imread(full_path_with_name);
    % Store the image in doubles values.
    doubled_image_data = im2double(image_data);
    
    % Create a figure where to display the original image.
    original_image_container = figure('Name', 'Original Image');
    colormap gray;
    imagesc(image_data);
    
    % Obtain/Set initial conditions for transformation.
    set(handles.mid_point, 'Min', min(min(doubled_image_data)));
    set(handles.mid_point, 'Max', max(max(doubled_image_data)));
    set(handles.mid_point, 'Value', mean2(doubled_image_data));
    
    % Now I create another figure where to display the modified image.
    modified_image_container = figure('Name', 'Enhanced Image');
    colormap gray;
    
    % Now get the histogram of the data for display.
    [counts, binCenters] = imhist(image_data);
    axes(handles.histogram_display);
    bar(binCenters, counts, 'barWidth', 1);
    grid on;
    
    % Store the data in GUIdata for later use.
    handles.image_data = image_data;
    handles.doubled_image_data = doubled_image_data;
    
    % Create a Figure to display the image
    handles.modified_picture_display = modified_image_container;
    guidata(hObject,handles);
end


% THIS FUNCTION EXECUTES WHEN THE SLIDER OF THE SLOPE VALUE IS MOVED TO
% RESULT IN AN ENHANCED IMAGE.
function slope_Callback(hObject, eventdata, handles)
    % Execute Contrast Stretching with the value of slope variation
    enhance_image_with_contrast_stretching(handles.doubled_image_data, get(hObject, 'Value'), handles.mid_point.Value, handles.modified_picture_display);
    % Set the current slope value to use in the other function.
    handles.current_slope_value = get(hObject, 'Value');
    guidata(hObject, handles);
end
% //////////////////////////////////////////////////////////////////


% FUNCTION THAT CALCULATES NEW IMAGE BASED ON THE VALUE SELECTED IN THE
% MIDPOINT SLIDER
function mid_point_Callback(hObject, eventdata, handles)
    % Execute Contrast Stretching with the value of the midpoint variation
    enhance_image_with_contrast_stretching(handles.doubled_image_data, handles.slope.Value, get(hObject, 'Value'), handles.modified_picture_display);
    % Set the current slope value to use in the other function.
    handles.current_midpoint_value = get(hObject, 'Value');
    guidata(hObject, handles);
end
% //////////////////////////////////////////////////////////////////////


% FUNCTION THAT CALCULATES NEW IMAGE BASED ONT HE VALUE CHOSEN FOR
% HISTOGRAM EQUALIZATION.
function normalization_value_Callback(hObject, eventdata, handles)
    % Perform calculation of histogram equalization with desired values.
    number_of_divisions = round(get(hObject, 'Value'));
    perform_histogram_equalization_with_values(handles.doubled_image_data, number_of_divisions, handles.modified_picture_display)
    % Set the current divisions value for the histogram equalization
    handles.current_histogram_division_value = get(hObject, 'Value');
    guidata(hObject, handles);
end
