function spider_plot(P, varargin)
% Thanks to Moses Yoo for most part of the code
% DO NOT CHANGE ANYTHING (unless you are moder)
%% Data Properties %%
% Point properties
[num_data_groups, num_data_points] = size(P);
% Number of optional arguments
numvarargs = length(varargin);
% Check for even number of name-value pair argments
if mod(numvarargs, 2) == 1
    error('Error: Please check name-value pair arguments');
end
% Create default labels
axes_labels = cell(1, num_data_points);
% Iterate through number of data points
for ii = 1:num_data_points
    % Default axes labels
    axes_labels{ii} = sprintf('Label %i', ii);
end
% Default arguments
axes_interval = 3;
axes_precision = 1;
axes_display = 'all';
axes_limits = [];
fill_option = 'off';
fill_transparency = 0.2;
colors = lines(num_data_groups);
line_style = '-';
line_width = 2;
marker_type = 'o';
marker_size = 8;
axes_font = 'Helvetica';
label_font = 'Helvetica';
axes_font_size = 10;
label_font_size = 10;
direction = 'clockwise';
axes_direction = 'normal';
axes_labels_offset = 0.1;
axes_scaling = 'linear';
axes_color = [0.6, 0.6, 0.6];
axes_labels_edge = 'k';
axes_offset = 1;
% Check if optional arguments were specified
if numvarargs > 1
    % Initialze name-value arguments
    name_arguments = varargin(1:2:end);
    value_arguments = varargin(2:2:end);
    
    % Iterate through name-value arguments
    for ii = 1:length(name_arguments)
        % Set value arguments depending on name
        switch lower(name_arguments{ii})
            case 'axeslabels'
                axes_labels = value_arguments{ii};
            case 'axesinterval'
                axes_interval = value_arguments{ii};
            case 'axesprecision'
                axes_precision = value_arguments{ii};
            case 'axesdisplay'
                axes_display = value_arguments{ii};
            case 'axeslimits'
                axes_limits = value_arguments{ii};
            case 'filloption'
                fill_option = value_arguments{ii};
            case 'filltransparency'
                fill_transparency = value_arguments{ii};
            case 'color'
                colors = value_arguments{ii};
            case 'linestyle'
                line_style = value_arguments{ii};
            case 'linewidth'
                line_width = value_arguments{ii};
            case 'marker'
                marker_type = value_arguments{ii};
            case 'markersize'
                marker_size = value_arguments{ii};
            case 'axesfont'
                axes_font = value_arguments{ii};
            case 'labelfont'
                label_font = value_arguments{ii};
            case 'axesfontsize'
                axes_font_size = value_arguments{ii};
            case 'labelfontsize'
                label_font_size = value_arguments{ii};
            case 'direction'
                direction = value_arguments{ii};
            case 'axesdirection'
                axes_direction = value_arguments{ii};
            case 'axeslabelsoffset'
                axes_labels_offset = value_arguments{ii};
            case 'axesscaling'
                axes_scaling = value_arguments{ii};
            case 'axescolor'
                axes_color = value_arguments{ii};
            case 'axeslabelsedge'
                axes_labels_edge = value_arguments{ii};
            case 'axesoffset'
                axes_offset = value_arguments{ii};
            otherwise
                error('Error: Please enter in a valid name-value pair.');
        end
    end
    
end
%% Error-Values Check %%
% Check if axes labels is a cell
if iscell(axes_labels)
    % Check if the axes labels are the same number as the number of points
    if length(axes_labels) ~= num_data_points
        error('Error: Please make sure the number of labels is the same as the number of points.');
    end
else
    % Check if valid char entry
    if ~contains(axes_labels, 'none')
        error('Error: Please enter in valid labels or "none" to remove labels.');
    end
end
% Check if axes limits is not empty
if ~isempty(axes_limits)
    % Check if the axes limits same length as the number of points
    if size(axes_limits, 1) ~= 2 || size(axes_limits, 2) ~= num_data_points
        error('Error: Please make sure the min and max axes limits match the number of data points.');
    end
    
    % Lower and upper limits
    lower_limits = axes_limits(1, :);
    upper_limits = axes_limits(2, :);
    
    % Difference in upper and lower limits
    diff_limits = upper_limits - lower_limits;
    
    % Check to make sure upper limit is greater than lower limit
    if any(diff_limits < 0)
        error('Error: Please make sure max axes limits are greater than the min axes limits.');
    end
    
    % Check the range of axes limits
    if any(diff_limits == 0)
        error('Error: Please make sure the min and max axes limits are different.');
    end
end
% Check if axes precision is numeric
if isnumeric(axes_precision)
    % Check is length is one
    if length(axes_precision) == 1
        % Repeat array to number of data points
        axes_precision = repmat(axes_precision, num_data_points, 1);
    elseif length(axes_precision) ~= num_data_points
        error('Error: Please specify the same number of axes precision as number of data points.');
    end
else
    error('Error: Please make sure the axes precision is a numeric value.');
end
% Check if axes properties are an integer
if floor(axes_interval) ~= axes_interval || any(floor(axes_precision) ~= axes_precision)
    error('Error: Please enter in an integer for the axes properties.');
end
% Check if axes properties are positive
if axes_interval < 1 || any(axes_precision < 0)
    error('Error: Please enter a positive value for the axes properties.');
end
% Check if axes display is valid char entry
if ~ismember(axes_display, {'all', 'none', 'one'})
    error('Error: Invalid axes display entry. Please enter in "all", "none", or "one" to set axes text.');
end
% Check if not a valid fill option arguement
if any(~ismember(fill_option, {'off', 'on'}))
    error('Error: Please enter either "off" or "on" for fill option.');
end
% Check if fill transparency is valid
if any(fill_transparency < 0) || any(fill_transparency > 1)
    error('Error: Please enter a transparency value between [0, 1].');
end
% Check if font size is greater than zero
if axes_font_size <= 0 || label_font_size <= 0
    error('Error: Please enter a font size greater than zero.');
end
% Check if direction is valid char entry
if ~ismember(direction, {'counterclockwise', 'clockwise'})
    error('Error: Invalid direction entry. Please enter in "counterclockwise" or "clockwise" to set direction of rotation.');
end
% Check if axes direction is valid char entry
if ~ismember(axes_direction, {'normal', 'reverse'})
    error('Error: Invalid axes direction entry. Please enter in "normal" or "reverse" to set axes direction.');
end
% Check if axes labels offset is positive
if axes_labels_offset < 0
    error('Error: Please enter a positive for the axes labels offset.');
end
% Check if axes scaling is valid
if any(~ismember(axes_scaling, {'linear', 'log'}))
    error('Error: Invalid axes scaling entry. Please enter in "linear" or "log" to set axes scaling.');
end
% Check if axes offset is valid
if floor(axes_offset)~=axes_offset || axes_offset < 0 || axes_offset > axes_interval
    error('Error: Invalid axes offset entry. Please enter in an integer value that is between [0, axes_interval].');
end
% Check if axes scaling is a cell
if iscell(axes_scaling)
    % Check is length is one
    if length(axes_scaling) == 1
        % Repeat array to number of data groups
        axes_scaling = repmat(axes_scaling, num_data_points, 1);
    elseif length(axes_scaling) ~= num_data_points
        error('Error: Please specify the same number of axes scaling as number of data points.');
    end
else
    % Repeat array to number of data groups
    axes_scaling = repmat({axes_scaling}, num_data_points, 1);
end
% Check if line style is a char
if ischar(line_style)
    % Convert to cell array of char
    line_style = cellstr(line_style);
    
    % Repeat cell to number of data groups
    line_style = repmat(line_style, num_data_groups, 1);
elseif iscellstr(line_style)
    % Check is length is one
    if length(line_style) == 1
        % Repeat cell to number of data groups
        line_style = repmat(line_style, num_data_groups, 1);
    elseif length(line_style) ~= num_data_groups
        error('Error: Please specify the same number of line styles as number of data groups.');
    end
else
    error('Error: Please make sure the line style is a char or a cell array of char.');
end
% Check if line width is numeric
if isnumeric(line_width)
    % Check is length is one
    if length(line_width) == 1
        % Repeat array to number of data groups
        line_width = repmat(line_width, num_data_groups, 1);
    elseif length(line_width) ~= num_data_groups
        error('Error: Please specify the same number of line width as number of data groups.');
    end
else
    error('Error: Please make sure the line width is a numeric value.');
end
% Check if marker type is a char
if ischar(marker_type)
    % Convert to cell array of char
    marker_type = cellstr(marker_type);
    
    % Repeat cell to number of data groups
    marker_type = repmat(marker_type, num_data_groups, 1);
elseif iscellstr(marker_type)
    % Check is length is one
    if length(marker_type) == 1
        % Repeat cell to number of data groups
        marker_type = repmat(marker_type, num_data_groups, 1);
    elseif length(marker_type) ~= num_data_groups
        error('Error: Please specify the same number of line styles as number of data groups.');
    end
else
    error('Error: Please make sure the line style is a char or a cell array of char.');
end
% Check if line width is numeric
if isnumeric(marker_size)
    if length(marker_size) == 1
        % Repeat array to number of data groups
        marker_size = repmat(marker_size, num_data_groups, 1);
    elseif length(marker_size) ~= num_data_groups
        error('Error: Please specify the same number of line width as number of data groups.');
    end
else
    error('Error: Please make sure the line width is numeric.');
end
% Check if axes direction is a cell
if iscell(axes_direction)
    % Check is length is one
    if length(axes_direction) == 1
        % Repeat array to number of data points
        axes_direction = repmat(axes_direction, num_data_points, 1);
    elseif length(axes_direction) ~= num_data_points
        error('Error: Please specify the same number of axes direction as number of data points.');
    end
else
    % Repeat array to number of data points
    axes_direction = repmat({axes_direction}, num_data_points, 1);
end
% Check if fill option is a cell
if iscell(fill_option)
    % Check is length is one
    if length(fill_option) == 1
        % Repeat array to number of data groups
        fill_option = repmat(fill_option, num_data_groups, 1);
    elseif length(fill_option) ~= num_data_groups
        error('Error: Please specify the same number of fill option as number of data groups.');
    end
else
    % Repeat array to number of data groups
    fill_option = repmat({fill_option}, num_data_groups, 1);
end
% Check if fill transparency is numeric
if isnumeric(fill_transparency)
    % Check is length is one
    if length(fill_transparency) == 1
        % Repeat array to number of data groups
        fill_transparency = repmat(fill_transparency, num_data_groups, 1);
    elseif length(fill_transparency) ~= num_data_groups
        error('Error: Please specify the same number of fill transparency as number of data groups.');
    end
else
    error('Error: Please make sure the transparency is a numeric value.');
end
%%% Axes Scaling Properties %%%
% Check axes scaling option
log_index = strcmp(axes_scaling, 'log');
% If any log scaling is specified
if any(log_index)
    % Initialize copy
    P_log = P(:, log_index);
    
    % Logarithm of base 10, account for numbers less than 1
    P_log = sign(P_log) .* log10(abs(P_log));
    
    % Minimum and maximun log limits
    min_limit = min(min(fix(P_log)));
    max_limit = max(max(ceil(P_log)));
    recommended_axes_interval = max_limit - min_limit;
    
    % Warning message
    warning('For the log scale values, recommended axes limit is [%i, %i] with an axes interval of %i.',...
        10^min_limit, 10^max_limit, recommended_axes_interval);
    
    % Replace original
    P(:, log_index) = P_log;
end
%% Figure Properties into Spider Graph %%
% Grab current figure
fig = gcf;
% Set figure background
fig.Color = 'white';
% Reset axes
cla reset;
% Current axes handle
ax = gca;
% Axis limits
hold on;
axis square;
axis([-1, 1, -1, 1] * 1.3);
% Axis properties
ax.XTickLabel = [];
ax.YTickLabel = [];
ax.XColor = 'none';
ax.YColor = 'none';
% Polar increments
theta_increment = 2*pi/num_data_points;
full_interval = axes_interval + 1;
rho_offset = axes_offset/full_interval;
%%% Scale Data %%%
% Pre-allocation
P_scaled = zeros(size(P));
axes_range = zeros(3, num_data_points);
% Check axes scaling option
axes_direction_index = strcmp(axes_direction, 'reverse');
% Iterate through number of data points
for ii = 1:num_data_points
    % Check for one data group and no axes limits
    if num_data_groups == 1 && isempty(axes_limits)
        % Group of points
        group_points = P(:, :);
    else
        % Group of points
        group_points = P(:, ii);
    end
    
    % Check for log axes scaling option
    if log_index(ii)
        % Minimum and maximun log limits
        min_value = min(fix(group_points));
        max_value = max(ceil(group_points));
    else
        % Automatically the range of each group
        min_value = min(group_points);
        max_value = max(group_points);
    end
    
    % Range of min and max values
    range = max_value - min_value;
    
    % Check if axes_limits is not empty
    if ~isempty(axes_limits)
        % Check for log axes scaling option
        if log_index(ii)
            % Logarithm of base 10, account for numbers less than 1
            axes_limits(:, ii) = sign(axes_limits(:, ii)) .* log10(abs(axes_limits(:, ii))); %#ok<AGROW>
        end
        % Manually set the range of each group
        min_value = axes_limits(1, ii);
        max_value = axes_limits(2, ii);
        range = max_value - min_value;
        
        % Check if the axes limits are within range of points
        if min_value > min(group_points) || max_value < max(group_points)
            error('Error: Please make the manually specified axes limits are within range of the data points.');
        end
    end
    
    % Scale points to range from [0, 1]
    P_scaled(:, ii) = ((P(:, ii) - min_value) / range);
    
    % If reverse axes direction is specified
    if axes_direction_index(ii)
        % Store to array
        axes_range(:, ii) = [max_value; min_value; range];
        P_scaled(:, ii) = -(P_scaled(:, ii) - 1);
    else
        % Store to array
        axes_range(:, ii) = [min_value; max_value; range];
    end
    
    % Add offset of [rho_offset] and scaling factor of [1 - rho_offset]
    P_scaled(:, ii) = P_scaled(:, ii) * (1 - rho_offset) + rho_offset;
end
%%% Polar Axes %%%
% Polar coordinates
rho_increment = 1/full_interval;
rho = 0:rho_increment:1;
% Check rotational direction
switch direction
    case 'counterclockwise'
        % Shift by pi/2 to set starting axis the vertical line
        theta = (0:theta_increment:2*pi) + (pi/2);
    case 'clockwise'
        % Shift by pi/2 to set starting axis the vertical line
        theta = (0:-theta_increment:-2*pi) + (pi/2);
end
% Remainder after using a modulus of 2*pi
theta = mod(theta, 2*pi);
% Iterate through each theta
for ii = 1:length(theta)-1
    % Convert polar to cartesian coordinates
    [x_axes, y_axes] = pol2cart(theta(ii), rho);
    
    % Plot webs
    h = plot(x_axes, y_axes,...
        'LineWidth', 1.5,...
        'Color', axes_color);
    
    % Turn off legend annotation
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
% Iterate through each rho
for ii = 2:length(rho)
    % Convert polar to cartesian coordinates
    [x_axes, y_axes] = pol2cart(theta, rho(ii));
    
    % Plot axes
    h = plot(x_axes, y_axes,...
        'Color', axes_color);
    
    % Turn off legend annotation
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
% Set end index depending on axes display argument
switch axes_display
    case 'all'
        theta_end_index = length(theta)-1;
    case 'one'
        theta_end_index = 1;
    case 'none'
        theta_end_index = 0;
end
% Rho start index and offset interval
rho_start_index = axes_offset+1;
offset_interval = full_interval - axes_offset;
% Iterate through each theta
for ii = 1:theta_end_index
    % Convert polar to cartesian coordinates
    [x_axes, y_axes] = pol2cart(theta(ii), rho);
    
    % Iterate through points on isocurve
    for jj = rho_start_index:length(rho)
        % Axes increment range
        min_value = axes_range(1, ii);
        range = axes_range(3, ii);
        
        % If reverse axes direction is specified
        if axes_direction_index(ii)
            % Axes increment value
            axes_value = min_value - (range/offset_interval) * (jj-rho_start_index);
        else
            % Axes increment value
            axes_value = min_value + (range/offset_interval) * (jj-rho_start_index);
        end
        
        % Check for log axes scaling option
        if log_index(ii)
            % Exponent to the tenth power
            axes_value = 10^axes_value;
        end
        
        % Display axes text
        text_str = sprintf(sprintf('%%.%if', axes_precision(ii)), axes_value);
        text(x_axes(jj), y_axes(jj), text_str,...
            'Units', 'Data',...
            'Color', 'k',...
            'FontName', axes_font,...
            'FontSize', axes_font_size,...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'middle');
    end
end
%% Plot %%
% Fill option index
fill_option_index = strcmp(fill_option, 'on');
% Iterate through number of data groups
for ii = 1:num_data_groups
    % Convert polar to cartesian coordinates
    [x_points, y_points] = pol2cart(theta(1:end-1), P_scaled(ii, :));
    
    % Make points circular
    x_circular = [x_points, x_points(1)];
    y_circular = [y_points, y_points(1)];
    
    % Plot data points
    plot(x_circular, y_circular,...
        'LineStyle', line_style{ii},...
        'Marker', marker_type{ii},...
        'Color', colors(ii, :),...
        'LineWidth', line_width(ii),...
        'MarkerSize', marker_size(ii),...
        'MarkerFaceColor', colors(ii, :));
    
    % Check if fill option is toggled on
    if fill_option_index(ii)
        % Fill area within polygon
        h = patch(x_circular, y_circular, colors(ii, :),...
            'EdgeColor', 'none',...
            'FaceAlpha', fill_transparency(ii));
        
        % Turn off legend annotation
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
end
% Find object handles
text_handles = findobj(ax.Children,...
    'Type', 'Text');
patch_handles = findobj(ax.Children,...
    'Type', 'Patch');
isocurve_handles = findobj(ax.Children,...
    'Color', axes_color,...
    '-and', 'Type', 'Line');
plot_handles = findobj(ax.Children, '-not',...
    'Color', axes_color,...
    '-and', 'Type', 'Line');
% Manually set the stack order
uistack(text_handles, 'bottom');
uistack(plot_handles, 'bottom');
uistack(patch_handles, 'bottom');
uistack(isocurve_handles, 'bottom');
%% Labels %%
% Check labels argument
if ~strcmp(axes_labels, 'none')
    % Convert polar to cartesian coordinates
    [x_axes, y_axes] = pol2cart(theta, rho(end));
    
    % Iterate through number of data points
    for ii = 1:length(axes_labels)
        % Angle of point in radians
        theta_point = theta(ii);
        
        % Find out which quadrant the point is in
        if theta_point == 0
            quadrant = 0;
        elseif theta_point == pi/2
            quadrant = 1.5;
        elseif theta_point == pi
            quadrant = 2.5;
        elseif theta_point == 3*pi/2
            quadrant = 3.5;
        elseif theta_point == 2*pi
            quadrant = 0;
        elseif theta_point > 0 && theta_point < pi/2
            quadrant = 1;
        elseif theta_point > pi/2 && theta_point < pi
            quadrant = 2;
        elseif theta_point > pi && theta_point < 3*pi/2
            quadrant = 3;
        elseif theta_point > 3*pi/2 && theta_point < 2*pi
            quadrant = 4;
        end
        
        % Adjust label alignment depending on quadrant
        switch quadrant
            case 0
                horz_align = 'left';
                vert_align = 'middle';
                x_pos = axes_labels_offset;
                y_pos = 0;
            case 1
                horz_align = 'left';
                vert_align = 'bottom';
                x_pos = axes_labels_offset;
                y_pos = axes_labels_offset;
            case 1.5
                horz_align = 'center';
                vert_align = 'bottom';
                x_pos = 0;
                y_pos = axes_labels_offset;
            case 2
                horz_align = 'right';
                vert_align = 'bottom';
                x_pos = -axes_labels_offset;
                y_pos = axes_labels_offset;
            case 2.5
                horz_align = 'right';
                vert_align = 'middle';
                x_pos = -axes_labels_offset;
                y_pos = 0;
            case 3
                horz_align = 'right';
                vert_align = 'top';
                x_pos = -axes_labels_offset;
                y_pos = -axes_labels_offset;
            case 3.5
                horz_align = 'center';
                vert_align = 'top';
                x_pos = 0;
                y_pos = -axes_labels_offset;
            case 4
                horz_align = 'left';
                vert_align = 'top';
                x_pos = axes_labels_offset;
                y_pos = -axes_labels_offset;
        end
        
        % Display text label
        text(x_axes(ii)+x_pos, y_axes(ii)+y_pos, axes_labels{ii},...
            'Units', 'Data',...
            'HorizontalAlignment', horz_align,...
            'VerticalAlignment', vert_align,...
            'EdgeColor', axes_labels_edge,...
            'BackgroundColor', 'w',...
            'FontName', label_font,...
            'FontSize', label_font_size);
    end
end