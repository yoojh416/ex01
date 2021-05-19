package org.jihyeong.service;

import java.util.List;

import org.jihyeong.domain.BoardVO;
import org.jihyeong.domain.Criteria;

public interface BoardService {
	public List<BoardVO> getList();
	List<BoardVO> getList(Criteria cri);
	public void register(BoardVO board);
	public BoardVO get(Long bno);
	public boolean modify(BoardVO board);
	public boolean remove(Long bno);
	public int getTotal(Criteria cri);
	
}
