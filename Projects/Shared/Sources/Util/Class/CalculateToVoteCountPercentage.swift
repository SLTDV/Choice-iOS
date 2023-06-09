import Foundation

public enum CalculateToVoteCountPercentage {
    public static func calculateToVoteCountPercentage(
        firstVotingCount: Double,
        secondVotingCount: Double
    ) -> (String, String, Int, Int) {
        let sum = firstVotingCount + secondVotingCount
        var firstP = firstVotingCount / sum * 100
        var secondP = secondVotingCount / sum * 100
        
        firstP = firstP.isNaN ? 0 : firstP
        secondP = secondP.isNaN ? 0 : secondP
        
        return (
            String(Int(firstP)),
            String(Int(secondP)),
            Int(firstVotingCount),
            Int(secondVotingCount)
        )
    }
}
