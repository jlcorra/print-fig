function print_fig(hfig, filename, format, size, style)
%PRINT_FIG Print figure to a file using specified format
%
%   Prints the figure with the handle hfig to the file filename at the 
%   specified size using a supported format. If a style is provided, then
%   this function will try to apply the corresponding properties to every 
%   plot, axis, label and legend object found under figure hfig.
%
%   PRINT_FIG(hfig, 'filename', 'format', [width, height])
%   PRINT_FIG(hfig, 'filename', 'format', [width, height], style)
%
%   Arguments:
%       hfig    : Figure handle to print
%       filename    : Filename without extension
%       format  : Output format. See SAVEAS for supported formats
%       width   : Printing width in points
%       height  : Printing height in points
%       style   : Struct array of figure properties to be overloaded
%
%   Examples:
%       print_fig(hf1, 'figure1', 'png', [350 275]);
%       print_fig(hf2, 'figure2', 'epsc2', [350 275], style);
%
%   See also: SAVEAS, PRINT.

% For the full copyright and license information, please view the LICENSE
% file that was distributed with this source code.
%
% @license http://opensource.org/licenses/MIT MIT License
% @copyright Copyright (c) 2014 Jos� L. Corrales

%% Recover figure handles
% Axis handles
hax = findall(hfig, 'Type', 'Axes');
hax = hax(~ismember(get(hax, 'Tag'), {'legend', 'colorbar'}));

% Plot handles
hpl = findall(hfig, 'Type', 'Line');

% Legend handles
hlg = findall(hfig, 'Type', 'Axes', 'Tag', 'legend');
%hlg = hlg(ismember(get(hlg, 'Interpreter'), {'latex'}));

%% Default printing format
print.fig.PaperUnits = 'points';
print.fig.PaperPositionMode = 'manual';
print.fig.PaperPosition = [0, 0, size(1), size(2)];

print.axis.Box = 'off';
print.axis.LineWidth = 1;

print.plot.LineWidth = 1;
print.plot.MarkerSize = 6;

%% Overload defaults with provided style
f1 = {'fig', 'plot', 'axis', 'label', 'legend'};
% Dynamic fieldnames are only supported in R2014a and above
if exist('style', 'var') && ~isempty(style)
    for i = find(isfield(style, f1))
        f2 = fieldnames(style.(f1{i}));
        for k = 1:length(f2)
            print.(f1{i}).(f2{k}) = style.(f1{i}).(f2{k});
        end
    end
end

%% Figure (printing size)
if isfield(print, 'fig') && ~isempty(print.fig)
    set(hfig, print.fig);
end

%% Plot lines & markers
if isfield(print, 'plot') && ~isempty(print.plot)
    set(hpl, print.plot);
end

%% Axis lines & ticks
% [!] Axis font is also applied to legends
if isfield(print, 'axis') && ~isempty(print.axis)
    set(hax, print.axis);
end

%% Axis labels & titles
% Axis labels & title
if isfield(print, 'label') && ~isempty(print.label)
    set(cell2mat(get(hax, {'XLabel', 'YLabel', 'Title'})), print.label);
end

%% Legends
if isfield(print, 'legend') && ~isempty(print.legend)
    set(hlg, print.legend);
end

%% Remove additional whitespace margins
% Undocumented property, might cause some issues with the LaTeX interpreter
LooseInset = get(hax, {'LooseInset'});
set(hax, {'LooseInset'}, get(hax, {'TightInset'}));

%% Print figure to file
saveas(hfig, filename, format);

%% Restore whitespace margins
set(hax, {'LooseInset'}, LooseInset);
end
