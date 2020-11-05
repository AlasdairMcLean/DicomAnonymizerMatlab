function dicomanonymizer
%Anonymizes MRI volume in order to comply with HIPAA regulations. Please
%ensure to manually check that there are no patient data files uploaded as
%a part of the MRI volume. This program simply removes the
%patient-identifying metadata intrinsically associated with the
%datastructure of the dicom; it does not determine if the visual content of
%each image may have sensitive information.

% *INPUTS*
%FolderPath - Directory to the folder containing the MRI scan.

% *OUTPUTS%
%FolderPathAnonymizedDicoms - Directory containing anonymized versions of
%input MRI volume scan
FolderPath = uigetdir('','Select the data folder');
mkdir([FolderPath 'Anonymized Dicoms'])

filedir=dir(FolderPath);
for i = 1:size(filedir,1)
    if filedir(i).isdir == 0
        if isdicom(char(strcat(FolderPath, '/', filedir(i).name))) == true
            filename = filedir(i).name;
            filenumber = "";
            digits=0;
            fileextension = [];
            for j=strlength(filename):-1:1 % go backwards through the filename
               if double(filename(j)) >= 48 && double(filename(j)) <=57 %if the single character we are looking at is a number, save it and look for other digits (if any) which are a part of the file number
                   digits = digits + 1;
               else
                   if digits ~= 0 && filenumber == ""
                       filenumber = filename(j+1:j+digits);
                   end
               end
               if double(filename(j)) == 46 && isempty(fileextension) %If we hit a period, indicating a potential extension
                    fileextension = filename(j:end); %then save the remainder as an extension
               end
            end
           file_in = strcat(FolderPath, '/', filedir(i).name);
           dicomanon(file_in, [FolderPath 'Anonymized Dicoms/' 'Anonymized' filenumber fileextension])
        end
    end
end




        
