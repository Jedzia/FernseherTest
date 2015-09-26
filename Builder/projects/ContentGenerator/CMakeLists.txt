##---------------------------------------------------------------------------
## $RCSfile$
## $Source$
## $Revision$
## $Date$
##---------------------------------------------------------------------------
## Author:      Jedzia
## Copyright:   (c) Jedzia, 2011
## License:     GPL License
##---------------------------------------------------------------------------
##---------------------------------------------------
## 
##--------------------------------------------------- 

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT( Humbug_Artwork )

SET(${PROJECT_NAME}_DIR "${CMAKE_CURRENT_SOURCE_DIR}"  CACHE TYPE PATH)
#SET(${PROJECT_NAME}_WORKDIR "${CMAKE_CURRENT_BINARY_DIR}"  CACHE TYPE PATH)
SET(${PROJECT_NAME}_WORKDIR "${PROJECT_SOURCE_DIR}/Work"  CACHE TYPE PATH)
#SET(Humbug_Artwork_OUTPUT_DIR ${PROJECT_SOURCE_DIR}/Work)
SET(NULL " ")

SET(Humbug_Artwork_Update_Target "Update_Artwork")

SET(USE_MAGICK TRUE)
SET(USE_INKSCAPE TRUE)

# local project settings
INCLUDE (bindings)

IF( ImageMagick_FOUND OR INKSCAPE_EXECUTABLE_FOUND )


IF(NOT IMGCONVERSION_CMAKE_DEBUG)
	SET(IMGCONVERSION_CMAKE_DEBUG OFF)
ENDIF()

set(IMGCONVERSION_TARGETS)


FUNCTION(ADD_IMGCONVERSION_TARGET _targetname _imgconv_output_dir _inp_image_source_file _format)

	#SET(_imgconv_output_dir ${PROJECT_SOURCE_DIR}/Work)
	SET(_additional_path ${ARGV4})

	GET_FILENAME_COMPONENT(_image_source_file  ${_inp_image_source_file} ABSOLUTE)
	GET_FILENAME_COMPONENT(_file_namef  ${_image_source_file} NAME)
	GET_FILENAME_COMPONENT(_file_ext  ${_image_source_file} EXT)
	GET_FILENAME_COMPONENT(_file_name  ${_image_source_file} NAME_WE)
	GET_FILENAME_COMPONENT(_file_path  ${_inp_image_source_file} PATH)
	file(RELATIVE_PATH _file_rel "${PROJECT_SOURCE_DIR}" "${_image_source_file}")
	GET_FILENAME_COMPONENT(_file_rel_path  ${_file_rel} PATH)
	IF(IMGCONVERSION_CMAKE_DEBUG)
		MESSAGE(STATUS "[IMGCONV] processing ${_file_namef}")
	ENDIF()
	
	SET(_imgconv_final_output_dir "${_imgconv_output_dir}/${_file_rel_path}")
	#MESSAGE(STATUS "[IMGCONV] _imgconv_final_output_dir: ${_imgconv_final_output_dir}")
	#MESSAGE(STATUS "[IMGCONV-XXX]  _additional_path=${_additional_path}")
	#MESSAGE(STATUS "[IMGCONV-XXX]  _file_rel=${_file_rel} _file_path=${_file_path} _image_source_file=${_image_source_file}")
	#SET(_out_file_fullpath  "${PROJECT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${_file_name}.${_format}")
	#SET(_out_file_fullpath  "${PROJECT_BINARY_DIR}/${_file_name}.${_format}")
	IF(_additional_path)
		SET(_out_file_fullpath  "${_imgconv_output_dir}/${_additional_path}/${_file_name}.${_format}")
		#MESSAGE(STATUS "[IMGCONV] HAS _additional_path")
	ELSE()
		SET(_out_file_fullpath  "${_imgconv_output_dir}/${_file_rel_path}/${_file_name}.${_format}")
	ENDIF()
	#MESSAGE(STATUS "[IMGCONV] output ${_out_file_fullpath}")


	SET(_inkscape_exts ".svg")
	list(FIND _inkscape_exts ${_file_ext} _val_found)
	IF(${_val_found} GREATER -1 AND INKSCAPE_EXECUTABLE_FOUND)
		# Inkscape part
		# inkscape --without-gui --file=$$i --export-png=$$o
#		MESSAGE(STATUS "[IMGCONV] USING INKSCAPE")
		
		SET(Build_Image_CMD ${INKSCAPE_EXECUTABLE})
		SET(Build_Image_OPTIONS --without-gui)
		#SET(Build_Image_ARGUMENTS --file=\"${_image_source_file}\" --export-png=\"${_file_name}.${_format}\")
		SET(Build_Image_ARGUMENTS --file=\"${_image_source_file}\" --export-png=\"${_out_file_fullpath}\")
	ELSE()
		# ImageMagick part
		# convert -layers merge infile.psd outfile.png
		SET(Build_Image_CMD ${IMAGEMAGICK_CONVERT_EXECUTABLE})
		SET(Build_Image_OPTIONS -layers merge)
		#SET(Build_Image_ARGUMENTS "\"${_image_source_file}\" \"${_file_name}.${_format}\"")
		SET(Build_Image_ARGUMENTS "\"${_image_source_file}\" \"${_out_file_fullpath}\"")
		#SET(Build_Image_ARGUMENTS "${_image_source_file}")

		IF(UNIX)
		  SEPARATE_ARGUMENTS(Build_Image_ARGUMENTS UNIX_COMMAND "${Build_Image_ARGUMENTS}")
		ENDIF(UNIX)
	ENDIF()

	#SEPARATE_ARGUMENTS(Build_Image_ARGUMENTS_LIST WINDOWS_COMMAND "${Build_Image_ARGUMENTS}")

#	MESSAGE(STATUS "[IMGCONV-X] DEPENDS ${_image_source_file}")
#	MESSAGE(STATUS "[IMGCONV-X] OUTPUT ${_out_file_fullpath}")
	
	ADD_CUSTOM_COMMAND(
		OUTPUT "${_out_file_fullpath}"
		POST_BUILD
		COMMAND ${Build_Image_CMD} ${Build_Image_OPTIONS} ${Build_Image_ARGUMENTS} && touch ${_imgconv_final_output_dir}
		DEPENDS "${_image_source_file}"
		COMMENT "Convert ${_file_namef} Image to ${_file_name}.${_format}." 
	)
	list(APPEND IMGCONVERSION_TARGETS "${_out_file_fullpath}")
	SET(IMGCONVERSION_TARGETS ${IMGCONVERSION_TARGETS} PARENT_SCOPE)
	SET_SOURCE_FILES_PROPERTIES("${_out_file_fullpath}" PROPERTIES GENERATED 1)

	IF(IMGCONVERSION_CMAKE_DEBUG)
		MESSAGE(STATUS "[IMGCONV] ${Build_Image_CMD} ${Build_Image_OPTIONS} ${Build_Image_ARGUMENTS}")
	ENDIF()
ENDFUNCTION() 

#ADD_IMGCONVERSION_TARGET(BI ${CMAKE_CURRENT_SOURCE_DIR}/footer.psd)

# Build Source-Side PNG Work Files out of PSD, SVG and EPS
#FILE(GLOB IMAGES_SOURCE_FILES ${PROJECT_SOURCE_DIR}/*.psd;${PROJECT_SOURCE_DIR}/*.svg)
FILE(GLOB_RECURSE IMAGES_SOURCE_FILES ${PROJECT_SOURCE_DIR}/*.psd;${PROJECT_SOURCE_DIR}/*.svg;${PROJECT_SOURCE_DIR}/*.eps)


SET(ADDITIONAL_IMAGES_SOURCE_FILES 
	    #${CMAKE_CURRENT_SOURCE_DIR}/Icons/nase.psd
	    ${CMAKE_CURRENT_SOURCE_DIR}/Icons/nase.psd
)

#SET(_und_const_match "(^D:/E/Projects/C\\+\\+/Humbug/projects/Humbug/Artwork/UnderConstruction/.*)")
SET(_und_const_match "${PROJECT_SOURCE_DIR}/UnderConstruction/")
FOREACH(f ${IMAGES_SOURCE_FILES})
		string(FIND "${f}" "${_und_const_match}" _und_const_result)
		#MESSAGE(STATUS "[IMGCONV] _und_const_result ${_und_const_result}.")
		#IF("${f}" MATCHES ${_und_const_match})
		IF(_und_const_result EQUAL 0)
			IF(IMGCONVERSION_CMAKE_DEBUG)
				MESSAGE(STATUS "[IMGCONV] Skipping ${f}.")
			ENDIF()
			LIST(REMOVE_ITEM IMAGES_SOURCE_FILES ${f} )
		ENDIF()
ENDFOREACH()


FOREACH(f ${IMAGES_SOURCE_FILES})
#		MESSAGE(STATUS "IMG: ${f}")
		ADD_IMGCONVERSION_TARGET(Artwork ${${PROJECT_NAME}_WORKDIR} ${f} png)
ENDFOREACH()

#ADD_IMGCONVERSION_TARGET(Artwork ${${PROJECT_NAME}_WORKDIR} Icons/nase.psd png AnotherFolder)

# ${IMAGEMAGICK_CONVERT_EXECUTABLE}
ADD_CUSTOM_TARGET(Artwork ALL DEPENDS ${IMGCONVERSION_TARGETS})
SET_TARGET_PROPERTIES(Artwork
	PROPERTIES
	#EXCLUDE_FROM_DEFAULT_BUILD
	EXCLUDE_FROM_ALL_BUILD
	TRUE
)

FUNCTION(fix_ffmpeg_path _inpath _outpath)
	string(REPLACE ":" "\\:" _my_outpath ${_inpath})
	set(${_outpath} ${_my_outpath} PARENT_SCOPE)
ENDFUNCTION() 

#ADD_CUSTOM_TARGET(Artwork ALL DEPENDS "${PROJECT_BINARY_DIR}/footer.png" "${PROJECT_BINARY_DIR}/footer2.png")
#ADD_CUSTOM_TARGET(Artwork ALL DEPENDS "${PROJECT_BINARY_DIR}/footer.png" )
#MESSAGE(STATUS "[IMGCONV-AAAA] IMGCONVERSION_TARGETS: ${IMGCONVERSION_TARGETS}")
#ADD_CUSTOM_TARGET(Artwork ALL DEPENDS "${PROJECT_BINARY_DIR}/footer.png" )
#ADD_DEPENDENCIES(Artwork ${PROJECT_BINARY_DIR}/footer2.png)

FILE(GLOB_RECURSE IMAGES_TRANSFER_FILES ${PROJECT_SOURCE_DIR}/Work/*.png;${PROJECT_SOURCE_DIR}/Work/*.jpg)
#MESSAGE(STATUS "[IMGCONV-LIST] IMAGES_TRANSFER_FILES: ${IMAGES_TRANSFER_FILES}")

#string(REPLACE "\n" ";" IMAGES_WORK_FILES ${IMAGES_WORK_FILES})
string(REPLACE "${PROJECT_SOURCE_DIR}/Work" "${PROJECT_BINARY_DIR}" IMAGES_WORK_FILES "${IMAGES_TRANSFER_FILES}")
#MESSAGE(STATUS "[IMGCONV-LIST] IMAGES_WORK_FILES:     ${IMAGES_WORK_FILES}")


#${IMAGES_TRANSFER_FILES}

foreach(convert_image ${IMAGES_TRANSFER_FILES})
	#MESSAGE(STATUS "[IMGCONV-LIST] loop_var:     ${loop_var}")

	string(REPLACE "${PROJECT_SOURCE_DIR}/Work" "${PROJECT_BINARY_DIR}" convert_image_out "${convert_image}")
	SET(RESIZESIZE 5120x2880)
	#SET(RESIZESIZE 2560x1440)
	# blah. does not work-> with add_custom_command files are cleaned. but its okay with add_custom_target. the operation is costly
	add_custom_command( 
	  OUTPUT ${convert_image_out}
	#  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/testcmake.txt testcmake.txt
	#  COMMAND xxd -i testcmake.txt testcmake.h
	#  COMMAND echo "${IMAGEMAGICK_MOGRIFY_EXECUTABLE}" -resize 1280x720 -path "${PROJECT_BINARY_DIR} ${PROJECT_SOURCE_DIR}/Work/*.png"
	#  COMMAND ${IMAGEMAGICK_MOGRIFY_EXECUTABLE} -resize 1280x720 -path "${PROJECT_BINARY_DIR} ${PROJECT_SOURCE_DIR}/Work/*.png"
	  COMMAND ${IMAGEMAGICK_CONVERT_EXECUTABLE} ${convert_image}  -quality 100 -resize ${RESIZESIZE} -background white -gravity center -extent ${RESIZESIZE} "${convert_image_out}"
	  DEPENDS ${convert_image}
	)


	get_filename_component(convert_image_target ${convert_image} NAME)
	ADD_CUSTOM_TARGET(MakeImage-${convert_image_target} ALL DEPENDS ${convert_image_out})
	#ADD_CUSTOM_TARGET(MakeImages ALL DEPENDS ${PROJECT_BINARY_DIR}/Options01.png)

endforeach()
#ADD_CUSTOM_TARGET(MakeImages ALL DEPENDS ${IMAGES_WORK_FILES})

#SET(SOUND_FILES_PATH Q:/Shared/Musik/Carcass)
SET(SOUND_FILES_PATH E:/Shared/Musi/Top500)
FILE(GLOB_RECURSE SOUND_FILES ${SOUND_FILES_PATH}/*.mp3;${SOUND_FILES_PATH}/*.wav)
list(LENGTH SOUND_FILES SOUND_FILES_LENGTH)

#FILE(GLOB_RECURSE SOUND_FILES ${PROJECT_SOURCE_DIR}/Work/*.png;${PROJECT_SOURCE_DIR}/Work/*.jpg)
#MESSAGE(STATUS "[IMGCONV-LIST] SOUND_FILES_LENGTH: ${SOUND_FILES_LENGTH}")

FUNCTION(get_random_soundfile pSoundfile)

# Show random integer from 0 to 9999.
string(RANDOM LENGTH 4 ALPHABET 0123456789 number)
math(EXPR number "${SOUND_FILES_LENGTH} * (${number} + 0) / 9999")  # Remove extra leading 0s.
#MESSAGE(STATUS "[IMGCONV-LIST] number: ${number}")
list(GET SOUND_FILES ${number} random_sound_file)

MESSAGE(STATUS "[IMGCONV-LIST] random_sound_file: ${random_sound_file}")
#set(${pSoundfile} "${random_sound_file}" PARENT_SCOPE)
set(${pSoundfile} "E:/Shared/Musi/Top500/227 - James Taylor - Fire And Rain (1970).mp3" PARENT_SCOPE)
ENDFUNCTION()

#get_random_soundfile(RANDOM_SOUNDFILE)


FUNCTION(build_intro_video pTitle pFPS pWIDTH pHEIGTH pEXTENSION pVCodec pAspect pAudio pExtra_Args)
separate_arguments(pExtra_Args)
#SET(pExtra_Args ${pExtra_Args} -loglevel panic -hide_banner) # Debug

SET(Title ${pTitle}) 
SET(FPS ${pFPS}) 
SET(WIDTH ${pWIDTH}) 
SET(HEIGTH ${pHEIGTH}) 
SET(EXTENSION ${pEXTENSION}.mpg)
SET(VCodec mpeg2video)
SET(Aspect ${pAspect})
SET(Extra_Args ${pExtra_Args})

SET(pBITRATE "-b:v 4M")
separate_arguments(pBITRATE)
SET(BITRATE "-b:v 32M") # Intermediate mpeg bitrate. 
separate_arguments(BITRATE)

SET(pTitle "${Title} ${pAspect} in ${pWIDTH}x${pHEIGTH} ${pFPS}fps") 
SET(pVIDEO_TITLE "${pTitle} als ${pEXTENSION}") 
SET(Text ${pVIDEO_TITLE})
string(REPLACE ":" "\\:" Text ${Text})
string(REPLACE ":" "t" pTitle ${pTitle})

SET(vAspect -aspect ${pAspect})

SET(Title "${Title} ${Aspect} in ${WIDTH}x${HEIGTH} at ${FPS}fps") 
string(REPLACE ":" "t" Title ${Title})
SET(VIDEO_PREFIX "${Title}_${VCodec}") 
SET(VIDEO_PREFIX2 "${Title}_${EXTENSION}_${VCodec}") 
SET(VIDEO_TARGET "${pTitle}_${pEXTENSION}_${pVCodec}") 
string(REPLACE " " "_" TTarget ${VIDEO_TARGET})

#SET(AUDIO -c:a copy)
#SET(AUDIO "-c:a libvo_aacenc -b:a 128k")
SET(Audio "-shortest -c:a ${pAudio} -b:a 128k")
if( ${pAudio} STREQUAL "${NULL}")
	SET(Audio "-an")
	#MESSAGE(STATUS "[IMGCONV-LIST] Audio is null:     ${TTarget}")
endif()
#SET(Audio "-an")
separate_arguments(Audio)

### video from image sequence
SET(GenVideo_OUT "${VIDEO_PREFIX2}_gen.${EXTENSION}")
#if(Extra_Args MATCHES ".*-aspect 4:3.*")
if(Aspect MATCHES "4:3")
	set(vf_rescale "crop=ih/3*4:ih,scale=${WIDTH}:${HEIGTH}")
#	MESSAGE(STATUS "[IMGCONV-LIST] vf_rescale:     ${vf_rescale}")
else()
	set(vf_rescale "scale=${WIDTH}:${HEIGTH}")
#	MESSAGE(STATUS "[IMGCONV-LIST] vf_rescale:     ${vf_rescale}")
endif()
add_custom_command(
  OUTPUT ${GenVideo_OUT}
  COMMAND cat ${PROJECT_BINARY_DIR}/Op* | ffmpeg -y -framerate 1/5 -f image2pipe  -vcodec png -i - -vf ${vf_rescale} -vcodec ${VCodec} ${vAspect} ${Extra_Args} ${BITRATE} -r ${FPS} ${GenVideo_OUT}
  DEPENDS ${IMAGES_WORK_FILES}
)
ADD_CUSTOM_TARGET(GenVideo${TTarget} ALL DEPENDS ${GenVideo_OUT})

# font size calculation
math(EXPR Fontsize "${pHEIGTH} / 36")
math(EXPR FontsizeBox "${pHEIGTH} / 14")
if(WIDTH LESS 721)
	math(EXPR Fontsize "${pHEIGTH} / 40")
	math(EXPR FontsizeBox "${pHEIGTH} / 17")
endif()

if(Aspect MATCHES "4:3")
	math(EXPR FontsizeBox "${pHEIGTH} / 21")
endif()

### overlay text video
fix_ffmpeg_path("${PROJECT_SOURCE_DIR}/Fonts/The_X-Files.ttf" Font)
set(ff_box "drawbox=y=ih/PHI/0.86:color=black@0.5:width=iw:height=ih/PHI/3.6:t=max")
set(ff_text "drawtext=fontfile='${Font}':text='${Text}':fontcolor=white:fontsize=${FontsizeBox}:x=\(w-tw\)/2:y=\(h/PHI/0.9\)+th")
separate_arguments(ff_text)
SET(FontOverlayVideo_OUT "${VIDEO_PREFIX2}_ovl.${EXTENSION}")
add_custom_command(
  OUTPUT ${FontOverlayVideo_OUT}
  COMMAND ffmpeg -y -i ${GenVideo_OUT} -vf \"${ff_box}, ${ff_text}, format=yuv420p\" -c:v ${VCodec} ${vAspect} ${Extra_Args} ${BITRATE} -an -movflags +faststart ${FontOverlayVideo_OUT}
  DEPENDS ${GenVideo_OUT}
)
ADD_CUSTOM_TARGET(FontOverlayVideo${TTarget} ALL DEPENDS ${GenVideo${TTarget}} ${GenVideo_OUT} ${FontOverlayVideo_OUT})

### fix Plasma Dimensions
SET(PlasmaFname ${PROJECT_SOURCE_DIR}/Videos/Plasma3.mp4)
SET(PlasmaVideo_OUTfname "Plasma-${VIDEO_TARGET}.${EXTENSION}")
SET(PlasmaVideo_OUTfname2 "Plasma-${VIDEO_TARGET}.tmp.${pEXTENSION}")
add_custom_command(
  OUTPUT ${PlasmaVideo_OUTfname} ${PlasmaVideo_OUTfname2}
  COMMAND ffmpeg -y -i ${PlasmaFname} -vf scale=${pWIDTH}:${pHEIGTH} -c:v ${VCodec} ${vAspect} ${Extra_Args} ${BITRATE} -an -movflags +faststart ${PlasmaVideo_OUTfname}
  COMMAND ffmpeg -y -i ${PlasmaFname} -vf scale=${pWIDTH}:${pHEIGTH} -c:v ${pVCodec} ${vAspect} ${pExtra_Args} ${pBITRATE} ${Audio} -movflags +faststart ${PlasmaVideo_OUTfname2}
  DEPENDS ${TextFileName}
)
ADD_CUSTOM_TARGET(PlasmaVideo${TTarget} ALL DEPENDS  ${PlasmaVideo_OUTfname} ${PlasmaVideo_OUTfname2})
#ADD_CUSTOM_TARGET(Plasma ALL DEPENDS  ${PlasmaVideo_OUTfname} ${PlasmaVideo_OUTfname2})

### MediaInfo 
SET(FontOverlayTEXT_OUT "${VIDEO_PREFIX2}_${EXTENSION}_ovl.txt")
add_custom_command(
  OUTPUT ${FontOverlayTEXT_OUT}
  COMMAND mediainfo ${PlasmaVideo_OUTfname2} | grep -v "Stream size" > ${FontOverlayTEXT_OUT}
  DEPENDS ${PlasmaVideo_OUTfname} ${PlasmaVideo_OUTfname2}
)
ADD_CUSTOM_TARGET(FontOverlayInfo${TTarget} ALL DEPENDS ${FontOverlayTEXT_OUT} ${PlasmaVideo${TTarget}})


### add a text page, remember to remove "Stream size  : 174 KiB (98%)"
fix_ffmpeg_path("${PROJECT_SOURCE_DIR}/Fonts/CONSOLA.TTF" Font)
SET(TextFileName ${FontOverlayTEXT_OUT})
fix_ffmpeg_path("${TextFileName}" TextFile)
set(ff_text "drawtext=fontfile='${Font}':textfile='${TextFile}':fontcolor=black:fontsize=${Fontsize}:y=2:x=10")
SET(FontOverlayVideo2_OUT "${VIDEO_PREFIX2}_ovl2.${EXTENSION}")
add_custom_command(
  OUTPUT ${FontOverlayVideo2_OUT}
  COMMAND ffmpeg -y -i ${PlasmaVideo_OUTfname} -vf \"${ff_text}, format=yuv420p\" -c:v ${VCodec} ${vAspect} ${Extra_Args} ${BITRATE} -c:a copy -movflags +faststart ${FontOverlayVideo2_OUT}
  DEPENDS ${TextFileName} ${PlasmaVideo_OUTfname2}
)
ADD_CUSTOM_TARGET(FontOverlayVideo2${TTarget} ALL DEPENDS ${GenVideo${TTarget}} ${GenVideo_OUT} ${FontOverlayVideo2_OUT})

### fix Intro Dimensions
SET(IntroFname ${PROJECT_SOURCE_DIR}/Videos/Intro01.mp4)
SET(IntroVideo_OUTfname "Intro-${VIDEO_TARGET}.${EXTENSION}")
add_custom_command(
  OUTPUT ${IntroVideo_OUTfname}
  COMMAND ffmpeg -y -i ${IntroFname} -vf scale=${pWIDTH}:${pHEIGTH} -c:v ${VCodec} ${vAspect} ${Extra_Args} ${BITRATE} -c:a copy -movflags +faststart ${IntroVideo_OUTfname}
  DEPENDS ${TextFileName}
)
ADD_CUSTOM_TARGET(IntroVideo${TTarget} ALL DEPENDS  ${IntroVideo_OUTfname})

### fix Outro Dimensions
SET(OutroFname ${PROJECT_SOURCE_DIR}/Videos/Outro01.mp4)
SET(OutroVideo_OUTfname "Outro-${VIDEO_TARGET}.${EXTENSION}")
add_custom_command(
  OUTPUT ${OutroVideo_OUTfname}
  COMMAND ffmpeg -y -i ${OutroFname} -vf scale=${pWIDTH}:${pHEIGTH} -c:v ${VCodec} ${vAspect} ${Extra_Args} ${BITRATE} -c:a copy -movflags +faststart ${OutroVideo_OUTfname}
  DEPENDS ${TextFileName}
)
ADD_CUSTOM_TARGET(OutroVideo${TTarget} ALL DEPENDS  ${OutroVideo_OUTfname})

### Target File for Video Concatenation 
SET(VideoConcatTEXT_OUT "${VIDEO_PREFIX2}_${EXTENSION}_lst.txt")
#fix_ffmpeg_path("${PROJECT_SOURCE_DIR}/Videos/Galileo-Heels.mkv" VideoConcat01)
file(WRITE ${PROJECT_BINARY_DIR}/${VideoConcatTEXT_OUT} 
    "file '${IntroVideo_OUTfname}'                             # Intro Video\n"
    "file '${FontOverlayVideo_OUT}'                            # Overlay with title bar\n"
    "file '${FontOverlayVideo2_OUT}'                           # Overlay with full text info\n"
#    "file '${GenVideo_OUT}'                                    # Generated Video\n"
#    "file '${PROJECT_SOURCE_DIR}/Videos/Galileo-Heels.mkv'     # Added Video\n"
    "file '${OutroVideo_OUTfname}'                             # Outro Video\n"
)
#ADD_CUSTOM_TARGET(VideoConcatTEXT${TTarget} ALL DEPENDS ${GenVideo${TTarget}} ${GenVideo_OUT} ${PROJECT_BINARY_DIR}/${VideoConcatTEXT_OUT})

### Video Concatenation 
#SET(VideoConcatVideo_OUT "${PROJECT_BINARY_DIR}/../${VIDEO_PREFIX2}.${EXTENSION}")
SET(VideoConcatVideo_OUT2 "${VIDEO_PREFIX2}.${EXTENSION}")
add_custom_command(
  OUTPUT ${VideoConcatVideo_OUT2}
  # This only works with some formats (MPEG-1, MPEG-2 PS, DV). 
  # see https://ffmpeg.org/faq.html#toc-Concatenating-using-the-concat-protocol-_0028file-level_0029
  COMMAND ffmpeg -y -f concat -i ${VideoConcatTEXT_OUT} -c:v copy -an -movflags +faststart ${VideoConcatVideo_OUT2}
  DEPENDS ${FontOverlayVideo2_OUT} ${PROJECT_BINARY_DIR}/${VideoConcatTEXT_OUT} ${IntroVideo_OUTfname} ${OutroVideo_OUTfname} ${GenVideo_OUT}
)
ADD_CUSTOM_TARGET(VideoConcatVideo2${TTarget} ALL DEPENDS ${VideoConcatVideo_OUT2})

#final video 
get_random_soundfile(Sound01)
SET(VIDEO_PREFIX2 "${pTitle}_${pEXTENSION}_${pVCodec}") 
SET(VideoConcatVideo_OUT "${PROJECT_BINARY_DIR}/../${VIDEO_PREFIX2}.${pEXTENSION}")
add_custom_command(
  OUTPUT ${VideoConcatVideo_OUT}
  # This only works with some formats (MPEG-1, MPEG-2 PS, DV). 
  # see https://ffmpeg.org/faq.html#toc-Concatenating-using-the-concat-protocol-_0028file-level_0029
  COMMAND ffmpeg -y -i ${Sound01} -i ${VideoConcatVideo_OUT2} -vf scale=${pWIDTH}:${pHEIGTH} -c:v ${pVCodec} ${vAspect} ${pExtra_Args} ${pBITRATE} ${Audio} -movflags +faststart ${VideoConcatVideo_OUT}
  DEPENDS ${VideoConcatVideo_OUT2}
)
ADD_CUSTOM_TARGET(VideoConcatVideo${TTarget} ALL DEPENDS ${VideoConcatVideo_OUT})

#SET(VIDEO_PREFIX2 "${pTitle}_${pEXTENSION}_${pVCodec}") 
#SET(VideoConcatVideo2_OUT "${PROJECT_BINARY_DIR}/../${VIDEO_PREFIX2}X.${pEXTENSION}")
#add_custom_command(
#  OUTPUT ${VideoConcatVideo2_OUT}
###  COMMAND ffmpeg -y -i ${Sound01} -i ${VideoConcatVideo_OUT} -c:v ${VCodec} ${Extra_Args} ${BITRATE} -c:a libvo_aacenc ${VideoConcatVideo2_OUT}
#  COMMAND ffmpeg -y -i ${Sound01} -i ${VideoConcatVideo_OUT} -c:v copy -shortest -c:a libvo_aacenc ${VideoConcatVideo2_OUT}
#  DEPENDS ${VideoConcatVideo_OUT}
#)
#ADD_CUSTOM_TARGET(VideoConcatVideoX${TTarget} ALL DEPENDS ${VideoConcatVideo2_OUT})

 
ENDFUNCTION() 







# not valid build_intro_video("Cisco openh264"          25 1280 720  mp4 libopenh264 ${NULL})

#if(TRUE)
#foreach(Container mkv mp4 avi)
#	foreach(LIB libx264 libxvid mpeg4)
#		foreach(RESOLUTION "720;576" "1280;720")
#			foreach(FPS 25 30 50 60)
#				#build_intro_video("X264"          ${FPS} 720  576  mkv libx264 16:9 ${NULL})
#				#build_intro_video("X264"          ${FPS} ${RESOLUTION}  mkv libx264 16:9 ${NULL})
#				build_intro_video("${LIB}"          ${FPS} ${RESOLUTION}  ${Container} ${LIB} 16:9 ${NULL})
#			endforeach(FPS)
#		endforeach(RESOLUTION)
#	endforeach(LIB)
#endforeach(Container)
#endif()

#build_intro_video("libtheora"          60 1280 720  avi libtheora 16:9 libvo_aacenc ${NULL})
#build_intro_video("libvpx"          60 1280 720  avi libvpx 16:9 libvo_aacenc ${NULL})
#build_intro_video("libvpx webm"          60 1280 720  webm libvpx 16:9 libvo_aacenc ${NULL})
#build_intro_video("libx265 exp"          25 1280 720  mkv libx265 16:9 libvo_aacenc "-strict experimental")
#build_intro_video("prores"          25 1280 720  mkv prores 16:9 libvo_aacenc ${NULL})
#build_intro_video("MPEG 1 Video"          25 1280 720  mpeg mpeg1video 16:9 libmp3lame ${NULL})
#build_intro_video("Theora"          25 1280 720  avi libtheora 16:9 libvo_aacenc ${NULL})

#if(FALSE)
#build_intro_video("X264"          25 720  576  mkv libx264 16:9 ${NULL} ${NULL})
##build_intro_video("X264 AAC"       25 720  576  mkv libx264 16:9 libvo_aacenc ${NULL})
#build_intro_video("X264"          25 720  576  mkv libx264 4:3 libvo_aacenc ${NULL})
#build_intro_video("X264"          25 1280 720  mkv libx264 16:9 libvo_aacenc ${NULL})
#build_intro_video("X264"          30 720  576  mkv libx264 16:9 libvo_aacenc ${NULL})
#build_intro_video("X264"          30 1280 720  mkv libx264 16:9 libvo_aacenc ${NULL})
#build_intro_video("X264"          30 1920 1080 mp4 libx264 16:9 libvo_aacenc ${NULL})
#build_intro_video("X264"          50 1920 1080 mp4 libx264 16:9 libvo_aacenc ${NULL})

#build_intro_video("MXF"       25 720   576  mxf mpeg2video 4:3 pcm_s16le "-ar 48000 -ac 2")
#build_intro_video("MXF"       25 1280  720  mxf mpeg2video 16:9 pcm_s16le "-ar 48000 -ac 2")
#build_intro_video("MXF"       25 1920  1080 mxf mpeg2video 16:9 pcm_s16le "-ar 48000 -ac 2")

#
##build_intro_video("X264"          30 720  576  mp4 libx264 16:9 libvo_aacenc ${NULL})
#build_intro_video("X264"          30 1024 768  mp4 libx264 16:9 libvo_aacenc ${NULL})
#build_intro_video("X264"          30 1280 720  mp4 libx264 16:9 libvo_aacenc ${NULL})
#build_intro_video("X264"          30 1280 720  mp4 libx264 4:3 libvo_aacenc ${NULL})
#
#build_intro_video("XVid"           30 720 576 mp4 libxvid 16:9 libvo_aacenc ${NULL})
#build_intro_video("XVid"           30 1280 720 mp4 libxvid 16:9 libvo_aacenc ${NULL})
#build_intro_video("XVid variable"  30 1280 720 mp4 libxvid 16:9 libvo_aacenc "-qscale:v 3")
#
#build_intro_video("mpeg4 native"   30 1280 720 avi mpeg4 16:9 libvo_aacenc ${NULL})
#
##build_intro_video("MPEG 2 Video"   30 720 576 mpg mpeg2video 16:9 libvo_aacenc ${NULL})
#build_intro_video("MPEG 2 Video"   30 720 576 mpg mpeg2video 16:9 libmp3lame ${NULL})
#build_intro_video("MPEG 2 Video"   30 1280 720 mpg mpeg2video 16:9 libvo_aacenc ${NULL})
#endif()

#build_intro_video("X264"          25 800  600  mkv libx264 4:3 libvo_aacenc ${NULL})
#build_intro_video("X264"           30 4096 2160 mp4 libx264 16:9 libvo_aacenc ${NULL})

#common formats
build_intro_video("XVid var"       30 1280  720  mp4 libxvid    16:9 libmp3lame   "-qscale:v 3")

build_intro_video("X264 AAC"       25 720   576  mkv libx264    4:3  libvo_aacenc ${NULL})
build_intro_video("X264 AAC"       25 1280  720  mkv libx264    16:9 libvo_aacenc ${NULL})

build_intro_video("X264 AAC"       25 1280  720  mp4 libx264    16:9 libvo_aacenc ${NULL})

build_intro_video("H265 AAC"       25 1280  720  mp4 libx265    16:9 libvo_aacenc "-strict experimental")

build_intro_video("X264 AAC"       25 1280  720  mp4 libx264    16:9 libvo_aacenc ${NULL})

build_intro_video("MXF"            25 720   576  mxf mpeg2video 4:3  pcm_s16le   "-ar 48000 -ac 2")
build_intro_video("MXF"            25 1280  720  mxf mpeg2video 16:9 pcm_s16le   "-ar 48000 -ac 2")

ELSE( ImageMagick_FOUND OR INKSCAPE_EXECUTABLE_FOUND )
	MESSAGE(STATUS "Not using ImageMagick.")
ENDIF( ImageMagick_FOUND OR INKSCAPE_EXECUTABLE_FOUND )
