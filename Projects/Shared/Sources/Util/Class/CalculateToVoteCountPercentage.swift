import Foundation

public final class CalculateToVoteCountPercentage {
    static func calculateToVoteCountPercentage(firstVotingCount: Double, secondVotingCount: Double) -> (String, String, Int, Int) {
        let sum = firstVotingCount + secondVotingCount
        var firstP = firstVotingCount / sum * 100.0
        var secondP = secondVotingCount / sum * 100.0
        
        firstP = firstP.isNaN ? 0.0 : firstP
        secondP = secondP.isNaN ? 0.0 : secondP
        
        let firstStr = String(format: "%0.2f", firstP)
        let secondStr = String(format: "%0.2f", secondP)
        
        return (firstStr, secondStr, Int(firstVotingCount), Int(secondVotingCount))
    }
}
