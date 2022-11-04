import CoreData
import CoreDataService
import UIKit

protocol MapsSnapshot<SectionIdentifierType, ItemIdentifierType> {
    associatedtype SectionIdentifierType: Hashable
    associatedtype ItemIdentifierType: Hashable

    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>

    func map(
        snapshotReference: NSDiffableDataSourceSnapshotReference,
        context: NSManagedObjectContext
    ) -> Snapshot
}

struct HostListSnapshotMapper: MapsSnapshot {
    typealias SectionIdentifierType = String
    typealias ItemIdentifierType = HostListSectionItem

    func map(
        snapshotReference: NSDiffableDataSourceSnapshotReference,
        context: NSManagedObjectContext
    ) -> Snapshot {
        let snapshotReference = snapshotReference as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        var snapshot = ContentSnapshot()

        snapshot.appendSections(snapshotReference.sectionIdentifiers)
        snapshot.sectionIdentifiers.forEach { (section: String) in
            let items = snapshotReference.itemIdentifiers(inSection: section)
                .compactMap { (managedObjectID: NSManagedObjectID) -> Host? in
                    context.object(with: managedObjectID) as? Host
                }
                .map { (host: Host) -> HostListCellViewModel in
                    HostListCellViewModel(
                        title: host.title,
                        iconName: host.iconName,
                        macAddress: host.macAddress
                    )
                }
                .map(HostListSectionItem.host)

            snapshot.appendItems(items, toSection: section)
        }

        return snapshot
    }
}
