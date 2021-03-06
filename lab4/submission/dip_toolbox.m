% This code will apply certain enhancements to the NASA images.
% First, we select the image that we want to analyze through a dialog

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
    % End initialization code - DO NOT EDIT
end

% ////////////////////////////////////////////////////
% Image Manipulation Functions
% Function to enhance the light pixels of the image selected
function enhance_image_with_contrast_stretching(data, slope_value, mid_point_value, display)
    stretched_contrast_image = 1./(1 + (mid_point_value./(data + eps)).^(slope_value));
    figure(display);
    imagesc(stretched_contrast_image);
end
% ////////////////////////////////////////////////////


% --- Executes just before dip_toolbox is made visible.
function dip_toolbox_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    % Update handles structure
    guidata(hObject, handles);
end


% --- Outputs from this function are returned to the command line.
function varargout = dip_toolbox_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end


% --- Executes on button press in save_image_button.
function save_image_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_image_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over save_image_button.
function save_image_button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to save_image_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in image_selector_button.
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


% --- Executes on slider movement.
function slope_Callback(hObject, eventdata, handles)
    % Execute Contrast Stretching with the value of slope variation
    enhance_image_with_contrast_stretching(handles.doubled_image_data, get(hObject, 'Value'), handles.mid_point.Value, handles.modified_picture_display);
    % Set the current slope value to use in the other function.
    handles.current_slope_value = get(hObject, 'Value');
    guidata(hObject, handles);
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


% --- Executes on slider movement.
function mid_point_Callback(hObject, eventdata, handles)
    % Execute Contrast Stretching with the value of the midpoint variation
    enhance_image_with_contrast_stretching(handles.doubled_image_data, handles.slope.Value, get(hObject, 'Value'), handles.modified_picture_display);
    % Set the current slope value to use in the other function.
    handles.current_midpoint_value = get(hObject, 'Value');
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function mid_point_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to mid_point (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
end
