package org.jihyeong.service;

import java.util.List;

import org.jihyeong.domain.BoardVO;
import org.jihyeong.domain.Criteria;
import org.jihyeong.mapper.BoardMapper;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService{
	private BoardMapper mapper;
	
	@Override
	public List<BoardVO> getList(){
		log.info("getList......");
		return mapper.getList();
	}
	@Override
	public List<BoardVO> getList(Criteria cri){
		log.info("getList with criteria: "+cri);
		return mapper.getListWithPaging(cri);
	}
	
	@Override
	public void register(BoardVO board) {
		log.info("register...."+board.getBno());
		mapper.insertSelectKey(board);
	}
	
	@Override
	public BoardVO get(Long bno) {
		log.info("get....."+bno);
		return mapper.read(bno);
	}
	
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify...."+board);
		return mapper.update(board)==1;
	}
	
	@Override
	public boolean remove(Long bno) {
		log.info("remove....."+bno);
		return mapper.delete(bno)==1;
	}
	
	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}
}
