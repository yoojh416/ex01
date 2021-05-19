package org.jihyeong.service;

import java.util.List;

import org.jihyeong.domain.Criteria;
import org.jihyeong.domain.ReplyVO;

public interface ReplyService {
	public List<ReplyVO> getList(Criteria cri, Long bno);
	public int register(ReplyVO vo);
	public ReplyVO get(Long rno);
	public int modify(ReplyVO vo);
	public int remove(Long rno);
}
