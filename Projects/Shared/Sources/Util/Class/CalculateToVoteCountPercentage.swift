import Foundation

public enum CalculateToVoteCountPercentage {
    public static func calculateToVoteCountPercentage(firstVotingCount: Double, secondVotingCount: Double) -> (String, String, Int, Int) {
        let sum = firstVotingCount + secondVotingCount
        let firstP = firstVotingCount / sum * 100
        let secondP = secondVotingCount / sum * 100
        
        let firstStr = (sum != 0) ? String(Int(firstP)) : String(firstP)
        let secondStr = (sum != 0) ? String(Int(secondP)) : String(secondP)
        
        return (firstStr, secondStr, Int(firstVotingCount), Int(secondVotingCount))
    }
}
