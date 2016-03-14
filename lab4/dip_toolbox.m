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


% ////////////////////////////////////////////////////
% Image Manipulation Functions
% Function to enhance the light pixels of the image selected
function  result = enhance_light_pixels_with_parameters(data, low_in, low_out, high_in, high_out, display)
result = imadjust(data,[0.3 0.7],[]);
figure(display);
imagesc(result);
% ////////////////////////////////////////////////////


% --- Executes just before dip_toolbox is made visible.
function dip_toolbox_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% Set all changeable values to 0 at the beginning
set(handles.input_low_value_label, 'String', num2str(0));
set(handles.input_high_value_label, 'String', num2str(0));


% --- Outputs from this function are returned to the command line.
function varargout = dip_toolbox_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function input_low_value_slider_Callback(hObject, eventdata, handles)
% hObject    handle to input_low_value_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Display what value is currently selected on the slider
set(handles.input_low_value_label, 'String', num2str(get(hObject,'Value')));
enhance_light_pixels_with_parameters(handles.image_data, get(hObject,'Value'), 0, 1, 0, handles.modified_picture_display);




% --- Executes during object creation, after setting all properties.
function input_low_value_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_low_value_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in save_image_button.
function save_image_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_image_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function input_high_value_slider_Callback(hObject, eventdata, handles)
% hObject    handle to input_high_value_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.input_high_value_label, 'String', num2str(get(hObject,'Value')));
% Apply the transformation to the image using the function created below
enhance_light_pixels_with_parameters(handles.image_data, get(hObject,'Value'), 0, 1, 0);

% --- Executes during object creation, after setting all properties.
function input_high_value_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_high_value_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over save_image_button.
function save_image_button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to save_image_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
    % Create a figure where to display the original image.
    original_image_container = figure('Name', 'Original Image');
    colormap gray;
    imagesc(image_data);
    % Now I create another figure where to display the modified image.
    modified_image_container = figure('Name', 'Enhanced Image');
    colormap gray;
    % Store the data in GUIdata for later use.
    handles.image_data = image_data;
    % Create a Figure to display the image
    handles.modified_picture_display = modified_image_container;
    guidata(hObject,handles)
    
% hObject    handle to image_selector_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
