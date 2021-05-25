package org.jihyeong.mapper;

import java.util.List;

import org.jihyeong.domain.BoardAttachVO;

public interface BoardAttachMapper {
	public void insert(BoardAttachVO vo);
	public void delete(String uuid);
	public List<BoardAttachVO> findByBNO(Long bno);
}
