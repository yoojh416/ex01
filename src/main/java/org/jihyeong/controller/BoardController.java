package org.jihyeong.controller;

import java.util.List;

import org.jihyeong.domain.BoardAttachVO;
import org.jihyeong.domain.BoardVO;
import org.jihyeong.domain.Criteria;
import org.jihyeong.domain.PageDTO;
import org.jihyeong.service.BoardService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	private BoardService service;
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list: "+cri);
		model.addAttribute("list",service.getList(cri));
		int total=service.getTotal(cri);
		log.info("total: "+total);
		model.addAttribute("pageMaker",new PageDTO(cri,total));
	}
	/*
	 * public void list(Model model) { 
	 * 	log.info("list");
	 * 	model.addAttribute("list",service.getList()); 
	 * }
	 */
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register: "+board);
		if(board.getAttachList()!=null) {
			board.getAttachList().forEach(attach->log.info(attach));
		}
		service.register(board);
		rttr.addFlashAttribute("result",board.getBno()); //addFlashAttribute()를 이용해서 단 한번만 전송되는 데이터 저장 후 전송
		return "redirect:/board/list";
		/* 리다이렉트를 하지 않고 새로고침을 할 경우 똑같은 글이 계속 insert 됨 */
	}
	
	@GetMapping("/register")
	public void register() {
		
	}
	
	@GetMapping({"/get","/modify"})
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("/get or modify");
		model.addAttribute("board",service.get(bno));
	}
	
	@PostMapping("/modify")
	public String get(BoardVO board,@ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify: "+board);
		if(service.modify(board)) {
			rttr.addFlashAttribute("result","success");
		}
		/*
		 * rttr.addAttribute("pageNum",cri.getPageNum());
		 * rttr.addAttribute("amount",cri.getAmount());
		 * rttr.addAttribute("type",cri.getType());
		 * rttr.addAttribute("keyword",cri.getKeyword());
		 */
		return "redirect:/board/list"+cri.getListLink();
	}
	
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("remove....."+bno);
		if(service.remove(bno)) {
			rttr.addFlashAttribute("result","success");
		}
		/*
		 * rttr.addAttribute("pageNum",cri.getPageNum());
		 * rttr.addAttribute("amount",cri.getAmount());
		 */
		return "redirect:/board/list"+cri.getListLink();
	}
	
	@GetMapping(value="/getAttachList", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		log.info("getAttachList "+bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
}
