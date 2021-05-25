package org.jihyeong.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.jihyeong.domain.AttachFileDTO;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	
	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload Form");
	}
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		String uploadFolder = "d:/upload";
		for(MultipartFile file : uploadFile) {
			log.info("-------------------");
			log.info(file.getOriginalFilename());
			log.info(file.getSize());
			File saveFile = new File(uploadFolder, file.getOriginalFilename());
			try {
				file.transferTo(saveFile);
			}catch (Exception e) {
				log.error(e.getMessage());
			}
		}
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload Ajax");
	}
	
	@PostMapping(value="/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		String uploadFolder = "d:/upload";
		List<AttachFileDTO> list = new ArrayList<>();
		File uploadPath = new File(uploadFolder, getFolder());
		log.info("uploadPath : " +uploadPath);
		if(uploadPath.exists()==false) {
			uploadPath.mkdirs();
		}
		for(MultipartFile multipartFile: uploadFile) {
			AttachFileDTO attachDTO = new AttachFileDTO();
			log.info("----------------------");
			log.info("upload File Name"+ multipartFile.getOriginalFilename());
			log.info("upload File Size"+ multipartFile.getSize());
			UUID uuid = UUID.randomUUID();
			String uploadFileName = multipartFile.getOriginalFilename();
			attachDTO.setFileName(uploadFileName);
			uploadFileName = uuid.toString()+"_"+uploadFileName;
			File saveFile = new File(uploadPath, uploadFileName);
			try {
				multipartFile.transferTo(saveFile);
				attachDTO.setUuid(uuid.toString()); attachDTO.setUploadPath(getFolder());
				if(checkImageType(saveFile)) {
					attachDTO.setImage(true);
					FileOutputStream thumbnail
					= new FileOutputStream(new File(uploadPath,"s_"+uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					thumbnail.close();
				}
				list.add(attachDTO); log.info("attachDTO"+attachDTO);
			}catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		return new ResponseEntity<>(list,HttpStatus.OK);
	}
	
	@GetMapping("/display")
	@ResponseBody//업로드 폴더에 있는 파일ㅣ 이미지라면 바이트로 읽어서 ResponseEntity로 보내줌
	public ResponseEntity<byte[]> getFile(String fileName){
		log.info("fileName : "+fileName);
		File file = new File("d:/upload/" + fileName);
		log.info("file : "+file);
		ResponseEntity<byte[]> result = null;
		try {
			org.springframework.http.HttpHeaders header = new org.springframework.http.HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath())+";charset=UTF-8");
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		}catch (Exception e) {e.printStackTrace();}
		return result;
	}
	
	@GetMapping(value="/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(String fileName){
		log.info("downloadFile : "+fileName);
		Resource resource = new FileSystemResource("d:/upload/"+fileName);
		if(resource.exists()==false) {return new ResponseEntity<>(HttpStatus.NOT_FOUND);}
		log.info("resource : "+resource);
		String resourceName = resource.getFilename();
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);
		log.info("resourceOriginalName : "+resourceOriginalName);
		org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
		try {
			headers.add("Content-Disposition","attachment; fileName="+new String(resourceOriginalName.getBytes("UTF-8"),"ISO-8859-1"));
		}catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		log.info("deleteFile: "+fileName);
		File file;
		try {
			file=new File("d:/upload/"+URLDecoder.decode(fileName,"UTF-8"));
			file.delete();
			if(type.equals("image")){
				String largeFileName=file.getAbsolutePath().replace("s_","");
				log.info("largeFileName: "+largeFileName);
				file=new File(largeFileName);
				file.delete();
			}
		}catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted",HttpStatus.OK);
	}
	
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			return contentType.startsWith("image");
		}catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
}
